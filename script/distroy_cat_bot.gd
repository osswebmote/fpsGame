extends Node3D

@export var INTENSIFY: float = 10.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for pieces: RigidBody3D in self.get_children():
		if pieces is RigidBody3D:
			pieces.apply_impulse(pieces.get_child(0).position* INTENSIFY + Vector3(1, 0, 0) * INTENSIFY * 1.5, self.global_position) #얘가 씬에 따라 실행이 안됨
			pass
		
	await get_tree().create_timer(2).timeout
	queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
