extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	size = screen_size / 2
	
	$right_top.position.x = size.x
	$left_bottom.position.y = size.y
	$right_bottom.position = size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
