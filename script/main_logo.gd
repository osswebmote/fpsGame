extends Sprite2D

func _process(delta: float) -> void:
	# 화면 크기 가져오기
	var screen_size = get_viewport_rect().size

	# 텍스처 크기 가져오기
	if texture:  # 텍스처가 설정되어 있는지 확인
		var texture_size = texture.get_size()

		# 스프라이트를 화면 중앙 하단에 배치
		position = Vector2((screen_size.x - texture_size.x * scale.x) / 2,  0)
