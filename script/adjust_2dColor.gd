extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 화면 크기 가져오기
	var screen_size = get_viewport().get_visible_rect().size

	# ColorRect의 크기를 화면의 절반으로 설정
	size = screen_size / 2

	# 색상을 초록색으로 설정
	color = Color(0, 0, 0, 0.3)  # RGB(0, 1, 0) = 초록색, Alpha(1) = 불투명

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_color():
	var shader_material = material as ShaderMaterial
	shader_material.set_shader_parameter("col", Color(0., 1.0, 0.0))
