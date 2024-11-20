extends Control

@onready var screen_size: Vector2i
@onready var pistol = get_tree().current_scene.get_node("Sketchfab_Scene")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport().size
	setTextPosition()
	
	$text_ready.modulate.a = 0
	$text_1.modulate.a = 0
	$text_2.modulate.a = 0
	$text_3.modulate.a = 0
	$text_start.modulate.a = 0

	var tween = create_tween().set_parallel(true)
	tween.tween_property($text_ready, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property($text_ready, "position", Vector2($text_ready.position.x, screen_size.y / 2), 1.0).set_trans(Tween.TRANS_SINE)
	
	tween.chain().tween_property($text_3, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property($text_ready, "modulate:a", 0.0, 0.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property($text_3, "position", Vector2($text_3.position.x, screen_size.y / 2), 1.0).set_trans(Tween.TRANS_SINE)
	
	tween.chain().tween_property($text_2, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property($text_3, "modulate:a", 0.0, 0.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property($text_2, "position", Vector2($text_2.position.x, screen_size.y / 2), 1.0).set_trans(Tween.TRANS_SINE)
	
	tween.chain().tween_property($text_1, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property($text_2, "modulate:a", 0.0, 0.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property($text_1, "position", Vector2($text_1.position.x, screen_size.y / 2), 1.0).set_trans(Tween.TRANS_SINE)
	
	tween.chain().tween_property($text_start, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property($text_1, "modulate:a", 0.0, 0.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property($text_start, "position", Vector2($text_start.position.x, screen_size.y / 2), 1.0).set_trans(Tween.TRANS_SINE)
	
	tween.chain().tween_property($text_start, "modulate:a", 0.0, 0.0).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(Callable(pistol, "set_speed"))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setTextPosition():
	var y_pos = 20
	var text_size = $text_ready.get_minimum_size()
	var position_x = (screen_size.x - text_size.x) / 2  # 화면 중앙
	var position_y = y_pos  # 화면 상단에서 약간 아래 (여백 설정)
	$text_ready.position = Vector2(position_x, position_y)
	
	text_size = $text_1.get_minimum_size()
	position_x = (screen_size.x - text_size.x) / 2  # 화면 중앙
	position_y = y_pos  # 화면 상단에서 약간 아래 (여백 설정)
	$text_1.position = Vector2(position_x, position_y)

	text_size = $text_2.get_minimum_size()
	position_x = (screen_size.x - text_size.x) / 2  # 화면 중앙
	position_y = y_pos  # 화면 상단에서 약간 아래 (여백 설정)
	$text_2.position = Vector2(position_x, position_y)

	text_size = $text_3.get_minimum_size()
	position_x = (screen_size.x - text_size.x) / 2  # 화면 중앙
	position_y = y_pos  # 화면 상단에서 약간 아래 (여백 설정)
	$text_3.position = Vector2(position_x, position_y)

	text_size = $text_start.get_minimum_size()
	position_x = (screen_size.x - text_size.x) / 2  # 화면 중앙
	position_y = y_pos  # 화면 상단에서 약간 아래 (여백 설정)
	$text_start.position = Vector2(position_x, position_y)
