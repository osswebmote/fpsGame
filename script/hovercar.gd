extends RigidBody3D
var object_type = 1

@onready var pistol = get_tree().current_scene.get_node("Sketchfab_Scene")
@onready var audioplayer = get_tree().current_scene.get_node("Sketchfab_Scene/car_crush_sound")

var rand_range = 5
var rand_x = randf_range(0, rand_range)
var rand_y = randf_range(0, rand_range)
var rand_z = randf_range(0, rand_range)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = get_random_position()
	if position.x > 0:
		self.apply_impulse(Vector3(-1, 0, 1) * 7, self.global_position)
	elif position.x == 0: 
		self.apply_impulse(Vector3(-1, -0.5, 0) * 20, self.global_position)
	elif position.x < 0:
		self.apply_impulse(Vector3(-1, 0, -1) * 7, self.global_position)
			
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):	
		audioplayer.play()
		pistol.start_collide_obstacle_effect()
		self.queue_free()
	pass

func get_random_position() -> Vector3:
	var x = 0
	var y = 10
	var z = randf_range(-5, 5)
	match randi_range(1, 3):
		1:
			x = -8
		2:
			x = 0
		3:
			x = 8
	return Vector3(x, y, z)
	
func _process(delta: float) -> void:
	apply_torque_impulse(Vector3(rand_x, rand_y, rand_z) * delta)
