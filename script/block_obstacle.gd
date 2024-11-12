extends RigidBody3D

@onready var pistol = get_tree().current_scene.get_node("Sketchfab_Scene")
@onready var target_destroy = preload("res://scene/block_obstacle_destroyed.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.add_to_group("enemy")
	position = get_random_position()
	freeze = 1
	pass # Replace with function body.
			
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):	
		var broken_model = target_destroy.instantiate()
		broken_model.transform = self.transform
		get_parent().add_child(broken_model) 
		
		pistol.start_collide_obstacle_effect()
		self.queue_free()

func hit():
	var broken_model = target_destroy.instantiate()
	broken_model.mode = 0 #총으로 부셨다고 알려주는 역할 
	broken_model.transform = self.transform
	get_parent().add_child(broken_model) 
	self.queue_free()



func get_random_position() -> Vector3:
	var x = 0
	var y = 1
	var z = randf_range(-5, 5)
	match randi_range(1, 3):
		1:
			x = -3
		2:
			x = 0
		3:
			x = 3
	return Vector3(x, y, z)
