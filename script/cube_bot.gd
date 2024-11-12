extends RigidBody3D

@onready var body = $"."
@export var up_down_amount : float
@export var time_multiple : float
@export var noise: FastNoiseLite
var base_y

var rand_index = randi_range(0, 100)
var rand_await_time = randf_range(0, 2)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = get_random_position()
	base_y = position.y
	body.freeze = 1 # freeze 1이 고정 0이 고정해제임 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#position.y = base_y + sin(Time.get_ticks_msec() * time_multiple) * up_down_amount #움직임 다 같게 하려면 이걸로 
	position.y = base_y + get_noise_from_seed(rand_index) * up_down_amount
	pass

func get_noise_from_seed(seed: int) -> float:
	noise.seed = seed
	return noise.get_noise_1d(Time.get_ticks_msec() * 0.01)

func hit():
	#var broken_model = target_destroy.instantiate()
	#broken_model.transform = self.transform
	#get_parent().add_child(broken_model) 
	get_tree().current_scene.math_score(1)
	self.queue_free()

func get_random_position() -> Vector3:
	var x = randf_range(-5, 5)
	var y = randf_range(3, 10)
	var z = randf_range(-5, 5)
	return Vector3(x, y, z)
