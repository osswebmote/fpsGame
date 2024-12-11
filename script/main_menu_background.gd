extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
			# 화면의 크기 가져오기
	var screen_size = get_viewport_rect().size
	var texture_size = texture.get_size()

	scale.x = (screen_size.x / texture_size.x) 
	scale.y = screen_size.y / texture_size.y
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		# 화면의 크기 가져오기
	var screen_size = get_viewport_rect().size
	var texture_size = texture.get_size()

	scale.x = (screen_size.x / texture_size.x) 
	scale.y = screen_size.y / texture_size.y
