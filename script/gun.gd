extends CharacterBody3D

enum {WALK, SHOT}
var curAnim = WALK

const SPEED = 800.0
const JUMP_VELOCITY = 4.5
@export var cam : Node3D
@export var weapon_holder: Node3D

@export var cam_rotation_amount: float = 1
@export var weapon_sway_amount: float = 5
@export var weapon_rotation_amount: float = 1
@onready var def_weapon_holder_pos = weapon_holder.position
@onready var animation = $cameraHolder/AnimationPlayer
@onready var animation_tree = $cameraHolder/AnimationTree
var target

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
	target = get_parent().get_node("Sketchfab_Scene")

func _physics_process(delta: float) -> void:
	weapon_tilt(delta)
	if Input.is_action_just_pressed("l_button_clicked"):
		#animation_tree.set("parameters/")
		animation.play("rig|Fire")
	
	if Input.is_action_just_pressed("R_down"):
		#animation.play("rig|Reload_Empty")
		animation.play("rig|Reload")
	
	if is_moving:
		move_to_target(delta)
	else:
		cam_tile(0, delta)
		if Input.is_action_just_pressed("ui_left"):
			change_rail(-1)
		elif Input.is_action_just_pressed("ui_right"):
			change_rail(1)
	velocity.x = SPEED * delta
	weapon_bob(1, delta)
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
	cam_tile(current_direction, delta)
	# 목표 위치에 도달하면 이동 완료
	if abs(global_transform.origin.z - target_position.z) < 0.05:
		global_transform.origin = Vector3(fixed_x, target_position.y, target_position.z)
		is_moving = false

func _input(event):
	# 마우스 클릭이 발생했는지 확인
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed: #1이 left버튼 눌린거임 2가 right버튼 0은 안눌
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
				#collider.freeze = 0
				collider.hit()
	
func cam_tile(direction, delta):
	if cam:
		cam.rotation.z = lerp(cam.rotation.z, direction * cam_rotation_amount, 5 * delta) 
		
func weapon_bob(vel: float, delta):
	if weapon_holder:
		if vel > 0:
			var bob_amount: float = 0.01
			var bob_freq: float = 0.01
			weapon_holder.position.y = lerp(weapon_holder.position.y, def_weapon_holder_pos.y + sin(Time.get_ticks_msec() * bob_freq) * bob_amount, 10 * delta)
			weapon_holder.position.x = lerp(weapon_holder.position.x, def_weapon_holder_pos.x + sin(Time.get_ticks_msec() * bob_freq * 0.5) * bob_amount, 10 * delta)
		else:
			weapon_holder.position.y = lerp(weapon_holder.position.y, def_weapon_holder_pos.y, 10 * delta)
			weapon_holder.position.x = lerp(weapon_holder.position.x, def_weapon_holder_pos.x, 10 * delta)

func weapon_tilt(delta):
	if weapon_holder:
		var camera_xyz = get_viewport().get_camera_3d()
		var mouse_position = get_viewport().get_mouse_position()
		var ray_origin = camera_xyz.project_ray_normal(mouse_position)
		var angle_z = ray_origin.z / 2
		var angle_y = -(ray_origin.y + 0.5) / 8 - 1.5
		weapon_holder.rotation.z = lerp(weapon_holder.rotation.z, -angle_z, 10 * delta)
		weapon_holder.rotation.x = lerp(weapon_holder.rotation.x, angle_y, 10 * delta)
