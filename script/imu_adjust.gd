extends Node3D

@onready var iphone = $iphone
@onready var guideline_container = $guideline_container
var click_count = 0

@onready var target_position = $guidecircle0.global_transform.origin

@onready var circle1_position0 = $guidecircle0.global_transform.origin
@onready var circle1_position1 = $guidecircle1.global_transform.origin
@onready var circle1_position2 = $guidecircle2.global_transform.origin
@onready var circle1_position3 = $guidecircle3.global_transform.origin
@onready var circle1_position4 = $guidecircle4.global_transform.origin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#guideline_container.look_at($guidecircle1.global_transform.origin, Vector3.UP)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	guideline_container.look_at(target_position, Vector3.UP)
	match click_count:
		1:
			target_position =  lerp(target_position, circle1_position1, delta * 5)
			guideline_container.look_at(target_position, Vector3.UP)
			iphone.look_at(target_position, Vector3.UP)
		2:
			target_position =  lerp(target_position, circle1_position2, delta * 5)
			guideline_container.look_at(target_position, Vector3.UP)
			iphone.look_at(target_position, Vector3.UP)
		3:
			target_position =  lerp(target_position, circle1_position3, delta * 5)
			guideline_container.look_at(target_position, Vector3.UP)
			iphone.look_at(target_position, Vector3.UP)
		4:
			target_position =  lerp(target_position, circle1_position4, delta * 5)
			guideline_container.look_at(target_position, Vector3.UP)
			iphone.look_at(target_position, Vector3.UP)
		5:
			target_position =  lerp(target_position, circle1_position0, delta * 5)
			guideline_container.look_at(target_position, Vector3.UP)
			iphone.look_at(target_position, Vector3.UP)
	pass

func _input(event):
	# 마우스 버튼 이벤트 확인
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if click_count < 5:
				click_count += 1
			match click_count:
				1:
					pass
				2:
					get_node("color_container/left_top").change_color()
				3:
					get_node("color_container/right_top").change_color()
				4:
					get_node("color_container/left_bottom").change_color()
				5:
					get_node("color_container/right_bottom").change_color()
			pass
