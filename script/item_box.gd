extends RigidBody3D
var object_type = 0

@onready var body = $"."
@onready var target_destroy = preload("res://scene/item_box_destroyed.tscn")
@onready var root = get_tree().current_scene

@export var up_down_amount : float
@export var time_multiple : float
@export var noise: FastNoiseLite

var base_x
var base_y
var base_z

var base_rotation_x
var base_rotation_y
var base_rotation_z

var rand_index = randi_range(0, 100)
var rand_await_time = randf_range(0, 2)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = get_random_position()
	base_y = position.y
	base_x = position.x
	base_rotation_x = rotation.x
	base_rotation_y = rotation.y
	base_rotation_z = rotation.z
	body.freeze = 1 # freeze 1이 고정 0이 고정해제임 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y = base_y + sin(Time.get_ticks_msec() * time_multiple * 0.3) * up_down_amount * 0.2
	#position.y = base_y + get_noise_from_seed(rand_index) * up_down_amount
	rotation.x = base_rotation_x + get_noise_from_seed(rand_index + 1) * up_down_amount 
	rotation.y = base_rotation_y + get_noise_from_seed(rand_index + 2) * up_down_amount 
	#rotation.z = base_rotation_z + get_noise_from_seed(rand_index + 3) * up_down_amount
	rotation.z += 0.02
	if base_x > 0:
		position.x -= delta * 3
	else:
		position.x += delta * 3

func get_noise_from_seed(seed: int) -> float:
	noise.seed = seed
	return noise.get_noise_1d(Time.get_ticks_msec() * time_multiple)

func hit():
	root.get_node("Sketchfab_Scene").set_on_shield()
	root.get_node("Sketchfab_Scene/on_shield_sound").play()
	root.on_shield_effect()
	var broken_model = target_destroy.instantiate()
	broken_model.transform = self.transform
	get_parent().add_child(broken_model) 
	
	get_tree().current_scene.math_score(1)
	self.queue_free()

func get_random_position() -> Vector3:
	var x = 0
	var y = randf_range(3, 10)
	var z = randf_range(-5, 5)
	if randf() > 0.5:
		x = 5
	else: 
		x = -5
	return Vector3(x, y, z)
