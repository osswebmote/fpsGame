extends Node3D
class_name InfinityWorld

var target_object = preload("res://scene/target1.tscn")
var car_preload = preload("res://scene/hovercar.tscn")
var cat_preload = preload("res://scene/cat_bot.tscn")
var item_preload = preload("res://scene/item_box.tscn")
var pistol_preload = preload("res://scene/pistol.tscn")
var broken_glass_preload = preload("res://sounds/broken_glass.mp3")
var car_crush_preload = preload("res://sounds/car_crush.wav")
var ingame_bgm_preload = preload("res://sounds/ingame_bgm.mp3")
var pistol_reload_preload = preload("res://sounds/pistol_reload2.mp3")
var pistol_sound_preload = preload("res://sounds/pistol_sound2.wav")
var run_in_road_preload = preload("res://sounds/run_in_road3.wav")
var shield_sound_preload = preload("res://sounds/shield_sound.wav")
var start_game_preload = preload("res://sounds/start_game.wav")

@export var mapArray: Array[PackedScene] = []
var amount = 3
var rng = RandomNumberGenerator.new()
var offset = 23
@onready var result_menu = $"ResultMenu"
var player_score = 0 
var max_bullet = 7
var bullet_count = max_bullet 
@onready var game_score = $game_score
@onready var game_time = $game_time
@onready var timer = $Timer
@onready var bullet_count_label = $bullet_count

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	result_menu.visible = false
	$item_effect.visible = false
	for n in range(amount):
		spawnMap(n*offset)
		pass
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_left_time()
	game_score.text ="score: " + str(player_score)
	pass

func spawnMap(n) -> void:
	rng.randomize()
	var num = rng.randi_range(0, mapArray.size() - 1)
	var instance = mapArray[num].instantiate()
	instance.position.x = n
	add_child(instance)

func _on_timer_timeout() -> void:
	#get_tree().paused = true #이거 변수에 담아서 쓰면 작동안함 직접 이렇게 세팅해야 댐 
	$Sketchfab_Scene.game_end()
	$Sketchfab_Scene2.stop_speed()
	$Sketchfab_Scene3.stop_speed()
	result_menu.visible = true
	game_score.visible = false
	game_time.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

func get_score () -> int:
	return player_score

func math_score(point) -> void:
	player_score += point

func set_left_time():
	var left_time = timer.time_left 
	var minute = int(left_time / 60)
	var sec = int(left_time - minute * 60)
	game_time.text = str(minute) + ":" + str(sec)

func put_bullet_label_count () -> void:
	bullet_count_label.text = str(bullet_count) + " / " + str(max_bullet)

func set_bullet_count (n) -> void:
	bullet_count -= n

func set_max_bullet_count () -> void:
	bullet_count = max_bullet
	
func get_bullet_count () -> int:
	return bullet_count

func on_shield_effect():
	$item_effect.visible = true
	pass

func off_shield_effect():
	$item_effect.visible = false
	pass
