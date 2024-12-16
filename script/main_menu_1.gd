extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_size = get_viewport_rect().size
	
	var tween = create_tween()
	$texture_start_btn.modulate = Color(1, 1, 1, 0) # 알파 값 0
	$texture_connect_btn.modulate = Color(1, 1, 1, 0) # 알파 값 0
	$texture_setting_btn.modulate = Color(1, 1, 1, 0) # 알파 값 0
	tween.parallel().tween_property($texture_start_btn, "modulate", Color(1, 1, 1, 1), 1.0)
	tween.parallel().tween_property($texture_connect_btn, "modulate", Color(1, 1, 1, 1), 1.0)
	tween.parallel().tween_property($texture_setting_btn, "modulate", Color(1, 1, 1, 1), 1.0)
	global_data.connect_svr()
	await get_tree().create_timer(2).timeout 
	$main_connect_code.text = "CONNECT CODE\n" + global_data.connect_id + "\n"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_start_btn_button_up() -> void:
	get_tree().change_scene_to_file("res://scene/loading.tscn")
	pass # Replace with function body.


func _on_texture_connect_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/connect_main.tscn")
	pass # Replace with function body.
