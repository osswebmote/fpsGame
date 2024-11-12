extends RigidBody3D

var body 
# Called when the node enters the scene tree for the first time.
@onready var target_destroy = preload("res://scene/target_destroy2.tscn")

func _ready() -> void:
	body =$"."
	position = get_random_position()
	body.freeze = 1 # freeze 1이 고정 0이 고정해제임 
	body.mass = 15.0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hit():
	var broken_model = target_destroy.instantiate()
	broken_model.transform = self.transform
	get_parent().add_child(broken_model)
	get_tree().current_scene.math_score(1)
	self.queue_free()

func get_random_position() -> Vector3:
	var x = randf_range(-5, 5)
	var y = randf_range(3, 10)
	var z = randf_range(-1, 12)
	return Vector3(x, y, z)
