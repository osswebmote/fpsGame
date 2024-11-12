extends Node3D
 
@onready var infinity_world = get_tree().current_scene
#@onready var target_object = preload("res://scene/target1.tscn")
@export var object_arr: Array[PackedScene] = []
@export var obstacle_arr: Array[PackedScene] = []
var object_chance: Array[float] = [0.2, 0.7 , 0.1]

@onready var map = $"."
@onready var parent = get_parent()
var speed = 10
var spawn_distance_from_player = 28
var activate_at_once = 1
var max_car = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if global_transform.origin.x - parent.get_node("Sketchfab_Scene").global_transform.origin.x < spawn_distance_from_player:
		if activate_at_once:
			for i in range(10):
				random_enemy_spawn()
			for i in range(randi_range(0,2)):
				random_obstacle_spawn()
			activate_at_once = 0

	if global_transform.origin.x - parent.get_node("Sketchfab_Scene").global_transform.origin.x < -infinity_world.offset:
		infinity_world.spawnMap(global_transform.origin.x + infinity_world.amount*infinity_world.offset)
		queue_free()


func random_enemy_spawn() -> void:
	var rand_chance = randf()  # 0과 1 사이의 랜덤 값
	var cumulative_chance = 0.0  # 누적 확률 초기화

	for i in range(object_arr.size()):
		cumulative_chance += object_chance[i]
		if rand_chance < cumulative_chance:
			var target = object_arr[i].instantiate()
			target.add_to_group("enemy")
			add_child(target)
			return
	
func random_obstacle_spawn() -> void:
	var rand_chance = randf()  # 0과 1 사이의 랜덤 값 생성
	var target
	if rand_chance < 0.7:
		target = obstacle_arr[0].instantiate()
		target.add_to_group("obstacle")
		add_child(target)	
	else:
		if !max_car:
			target = obstacle_arr[1].instantiate()
			max_car = true
			target.add_to_group("obstacle")
			add_child(target)	
