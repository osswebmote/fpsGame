extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 화면 크기 가져오기
	var screen_size = get_viewport_rect().size

	# 텍스처 크기 가져오기
	var texture_size = texture.get_size()

	# x 좌표를 화면 오른쪽에서 100px 떨어진 위치에 설정하고, y 좌표는 기본값 유지
	position.x = screen_size.x - texture_size.x * scale.x - 25
	position.y = screen_size.y - texture_size.y * scale.y - 200
