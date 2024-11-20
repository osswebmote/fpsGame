extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 화면 크기 가져오기
	var screen_size = get_viewport_rect().size

	# 텍스처 크기 가져오기
	var texture_size = self.get_size()

	# 스프라이트를 화면 중앙 하단에 배치
	position = Vector2(
		(screen_size.x - texture_size.x * scale.x) / 2,  # 가로 중앙
		screen_size.y - texture_size.y * scale.y         # 화면 아래
	)
