extends Node3D
var SPEED = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += SPEED * delta
	pass

func set_speed():
	SPEED = 11

func stop_speed():
	SPEED = 0
