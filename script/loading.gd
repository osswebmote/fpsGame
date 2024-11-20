extends Node2D

@export var loading_bar : ProgressBar
var progress : Array  = [0.0]
var scene_path : String
var prev_progress = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_path = "res://scene/infinityWorld.tscn"
	ResourceLoader.load_threaded_request(scene_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ResourceLoader.load_threaded_get_status(scene_path, progress)
	if progress[0] > prev_progress:
		prev_progress = progress[0]
	if loading_bar.value < prev_progress:
		loading_bar.value = lerp(loading_bar.value, prev_progress, delta )
	loading_bar.value += delta * 0.2 *(0.5 if prev_progress >= 1.0 else clamp(0.9 - loading_bar.value, 0.0, 1.0))
	
	if loading_bar.value >= 1.0:
		get_tree().change_scene_to_packed(
			ResourceLoader.load_threaded_get(scene_path)
		)
