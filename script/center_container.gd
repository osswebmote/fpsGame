extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 화면의 크기 가져오기
	var screen_size = get_viewport_rect().size
	var self_size = self.get_size()

	# 화면 크기에 맞게 스프라이트의 Scale 설정
	scale.x = (screen_size.x / self_size.x)
	scale.y = screen_size.y / self_size.y
