extends Node3D

@onready var speed = get_tree().current_scene.get_node("Sketchfab_Scene").SPEED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += 11 * delta
	pass
