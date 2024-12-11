extends CharacterBody3D

enum {WALK, SHOT}
var curAnim = WALK

var SPEED = 0 
var prev_velocity = 0.0
@export var cam : Node3D
@export var weapon_holder: Node3D

@export var cam_rotation_amount: float = 1
@export var weapon_sway_amount: float = 5
@export var weapon_rotation_amount: float = 1
@onready var def_weapon_holder_pos = weapon_holder.position

@onready var animation = $cameraHolder/AnimationPlayer
@onready var animation_tree = $cameraHolder/AnimationTree
@onready var shot_sound = $shot_sound
@onready var reload_sound = $reload_sound
@onready var run_sound = $run_sound
@onready var break_glass_sound = $break_glass_sound
@onready var break_crush_sound = $car_crush_sound
@onready var on_shield_sound = $on_shield_sound
@onready var game_bgm = $game_bgm

#카메라 흔들림 초기변수들
@onready var initial_rotation = cam.rotation_degrees as Vector3
@export var trauma_reduction_rate := 1.0
@export var max_x := 10.0
@export var max_y := 10.0
@export var max_z := 5.0
@export var noise: FastNoiseLite
@export var noise_speed := 50.0
@export var score_popup : PackedScene

var trauma := 0.5
var time := 0.0

#애니메이션 상태관리 변수
var is_game_start = false
var is_shooting = false
var is_sliding = false
var reload_available = true
var is_collide = false
var is_shield = false
var is_bgm = false

#인게임 요소
@onready var target = get_parent().get_node("Sketchfab_Scene")
@onready var root = get_tree().current_scene
@onready var max_bullet = root.max_bullet
@onready var bullet_count = root.bullet_count

# 레일 위치를 나타내는 배열
var rail_positions = [Vector3(0, 0, -3), Vector3(0, 0, 0), Vector3(0, 0, 3)]
var move_progress = 0.0 # 이동 진행률 (0.0 ~ 1.0)
var move_duration = 0.5 # 이동 시간 (초 단위, 조정 가능)
var target_position = Vector3()
var start_position = Vector3()

# 현재 레일 인덱스
var current_rail_index = 1
# 이동 속도 (조정 가능)
var dash_speed = 10.0
# 레일 변경 여부
var is_moving = false
var current_direction;

func _ready() -> void:
	game_bgm.play()
	game_bgm.stop()
	
	self.add_to_group("player")
	await get_tree().create_timer(1).timeout
	$count_number.play()
	pass

func _physics_process(delta: float) -> void:
	if is_game_start and !is_bgm:
		game_bgm.play()
		is_bgm = true
		pass
		
	if not run_sound.is_playing() and is_game_start:
		run_sound.play()

	weapon_sway(delta)
	if Input.is_action_just_pressed("l_button_clicked"):
		if is_game_start and !is_shooting and !is_moving and bullet_count > 0.1:
			is_shooting = true
			shot_sound.play()
			animation.play("Shoot")
			trauma = 0.8
			root.set_bullet_count(1)
			bullet_count = root.get_bullet_count()
			root.put_bullet_label_count ()
			
			await get_tree().create_timer(0.5).timeout
			is_shooting = false
		
	if  bullet_count <= 0.1 and reload_available and !is_shooting:
		is_shooting = true
		reload_available = false

		reload_sound.play()
		animation.play("Reload")
		await get_tree().create_timer(1.8).timeout
		
		root.set_max_bullet_count()
		bullet_count = root.get_bullet_count()
		root.put_bullet_label_count ()
		
		reload_available = true
		is_shooting = false
		
	if is_moving:
		move_to_target(delta)
	else:
		#cam_tilt(0, delta)
		if Input.is_action_just_pressed("move_left"):
			change_rail(-1)
		elif Input.is_action_just_pressed("move_right"):
			change_rail(1)
			
	if is_shooting:
		cam_shake(delta)
	else:
		cam.rotation_degrees = lerp(cam.rotation_degrees, initial_rotation, 5 * delta) 
	
	if is_collide:
		collide_obstacle_effect(delta)
		
	weapon_bob(1, delta)
	
	prev_velocity = lerp(prev_velocity, SPEED * delta, 5 * delta)
	velocity.x = prev_velocity
	move_and_slide()
	
# 레일 변경 함수
func change_rail(direction):
	var new_index = current_rail_index + direction
	if new_index >= 0 and new_index < rail_positions.size():
		current_direction = direction
		current_rail_index = new_index
		target_position = rail_positions[current_rail_index]
		start_position = global_transform.origin
		move_progress = 0.0
		is_moving = true

# 목표 위치로 부드럽게 이동
func move_to_target(delta):
	var target_position = rail_positions[current_rail_index]
	# 이동 진행률을 업데이트하고 1.0을 넘지 않도록 제한
	move_progress += delta / move_duration
	move_progress = clamp(move_progress, 0.0, 1.0)
	var eased_progress = ease(move_progress, 0.2) #0.0~1.0 사이의 수가 각각의 커프 값으로 구분되어 있음 설명서 참고하기
	var fixed_x = global_transform.origin.x
	var new_position = start_position.move_toward(target_position, eased_progress * target_position.distance_to(start_position))
	global_transform.origin = Vector3(fixed_x, new_position.y, new_position.z)
	#카메라 좌우 기울이는 이펙트 
	cam_tilt(current_direction, delta)
	
	# 목표 위치에 도달하면 이동 완료
	if abs(global_transform.origin.z - target_position.z) < 0.05:
		global_transform.origin = Vector3(fixed_x, target_position.y, target_position.z)
		is_moving = false

#총으로 쐈을 때 피격 판정 매커니즘이 들어가 있음
func _input(event):
	# 마우스 클릭이 발생했는지 확인
	if is_game_start and event is InputEventMouseButton and event.button_index == 1 and event.pressed and !is_shooting: #1이 left버튼 눌린거임 2가 right버튼 0은 안눌림
		# 현재 화면에 표시된 카메라 가져오기
		var camera = get_viewport().get_camera_3d()
		
		# 클릭된 화면 위치를 기준으로 레이 발사 시작점과 방향 벡터 계산림
		var from = camera.project_ray_origin(event.position)
		var to_normal = camera.project_ray_normal(event.position)
		var to = from + to_normal * 1000  # 레이의 방향과 길이 설정
		var power = 20.0
		
		# 레이와 충돌 검사 수행
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result = space_state.intersect_ray(query)
		
		#충돌 지점이 있는 경우 해당 위치 가져오기
		if result:
			var collider = result.collider
			var click_position = result.position  # 월드 좌표계의 충돌 지점
			if collider.is_in_group("enemy"): # 충돌한 객체가 target인지 확인
				collider.hit()
				start_score_popup(event.position, collider.object_type)

func imu_input(event):
	#여기에 위 _input코드들 가져와서 넣고 스마트폰으로 터치했을 때 이 함수 실행 시키도록 세팅하는게 좋을 듯 
	pass
	
func cam_tilt(direction, delta):
	if cam:
		cam.rotation.x = lerp(cam.rotation.x, direction * cam_rotation_amount, 5 * delta) 
		
func weapon_bob(vel: float, delta):
	if is_game_start and weapon_holder:
		if vel > 0:
			var bob_amount: float = 0.01
			var bob_freq: float = 0.01
			weapon_holder.position.y = lerp(weapon_holder.position.y, def_weapon_holder_pos.y + sin(Time.get_ticks_msec() * bob_freq) * bob_amount, 10 * delta)
			weapon_holder.position.z = lerp(weapon_holder.position.z, def_weapon_holder_pos.x + sin(Time.get_ticks_msec() * bob_freq * 0.5) * bob_amount, 10 * delta)
		else:
			weapon_holder.position.y = lerp(weapon_holder.position.y, def_weapon_holder_pos.y, 10 * delta)
			weapon_holder.position.z = lerp(weapon_holder.position.z, def_weapon_holder_pos.x, 10 * delta)

func weapon_sway(delta):
	if weapon_holder:
		var camera_xyz = get_viewport().get_camera_3d()
		var mouse_position = get_viewport().get_mouse_position()
		var ray_origin = camera_xyz.project_ray_normal(mouse_position)
		var angle_z = ray_origin.z / 2
		var angle_y = -(ray_origin.y + 1.0) / 10 - 1.5
		weapon_holder.rotation.z = lerp(weapon_holder.rotation.z, -angle_z, 10 * delta)
		weapon_holder.rotation.x = lerp(weapon_holder.rotation.x, angle_y, 10 * delta)

func add_trauma(trauma_amount: float):
	trauma = clamp(trauma + trauma_amount, 0.0, 0.8)

func get_shake_intensity() -> float:
	return trauma * trauma

func get_noise_from_seed(seed: int) -> float:
	noise.seed = seed
	return noise.get_noise_1d(time * noise_speed)

func cam_shake(delta) -> void:
	time += delta
	trauma = max(trauma - delta * trauma_reduction_rate, 0.0)
	
	cam.rotation_degrees.x = initial_rotation.x + max_x * get_shake_intensity() * get_noise_from_seed(0) 
	cam.rotation_degrees.y = initial_rotation.y + max_y * get_shake_intensity() * get_noise_from_seed(1) 
	cam.rotation_degrees.z = initial_rotation.z + max_z * get_shake_intensity() * (1 + get_noise_from_seed(2) / 2) 
	
func collide_obstacle_effect(delta):
	time += delta
	trauma = max(trauma - delta * trauma_reduction_rate, 0.0)
	
	cam.rotation_degrees.x = initial_rotation.x + 60 * get_shake_intensity() * get_noise_from_seed(0) 
	cam.rotation_degrees.y = initial_rotation.y + 60 * get_shake_intensity() * get_noise_from_seed(1) 
	cam.rotation_degrees.z = initial_rotation.z + 60 * get_shake_intensity() * get_noise_from_seed(2)
	if (trauma < 0.01):
		is_collide = false

func start_collide_obstacle_effect():
	if !is_collide and !is_shield:
		trauma = 1.0
		root.math_score(-3)
		#이 부분에 피격시 점수 깍이는 애니메이션 추가
		var screen_size = root.get_viewport().get_visible_rect().size
		screen_size /= 2
		start_score_popup(screen_size,-3)
		is_collide = true 
	is_shield = false
	root.off_shield_effect()

func set_on_shield ():
	is_shield = true
	
func set_off_shield ():
	is_shield = false

func set_speed():
	SPEED = 800.0
	is_game_start = true
	root.get_node("Sketchfab_Scene2").set_speed()
	root.get_node("Sketchfab_Scene3").set_speed()
	
func start_score_popup(score_position : Vector2, n : int):
	var popup = score_popup.instantiate()
	popup.position = score_position  
	if n > 0:
		popup.text = "+" + str(n)  
	elif n < 0:
		popup.modulate = Color(1,0.05,0.05)
		popup.scale = Vector2(3, 3)
		popup.text = str(n)
	else:
		popup.text = ""  
	get_parent().add_child(popup)

func game_end ():
	is_game_start = false
	SPEED = 0
