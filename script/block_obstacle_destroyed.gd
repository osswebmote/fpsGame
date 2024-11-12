extends Node3D

@export var INTENSIFY: float = 10.0
@export var gravity_strength: float = -9.8  # 중력 가속도 설정
@onready var audioplayer = get_tree().current_scene.get_node("Sketchfab_Scene/break_glass_sound")

var mode = 1 #1이면 플레이어랑 충돌하는 애니메이션, 0이면 총으로 부셔지는 애니메이션 실행 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audioplayer.play()
	if mode == 1: #플레이어 충돌로 인한 애니메이션
		for pieces: RigidBody3D in self.get_children():
			if pieces is RigidBody3D:
				pieces.apply_impulse(pieces.get_child(0).position* INTENSIFY + Vector3(1, 0, 0) * INTENSIFY * 2, self.global_position) #얘가 씬에 따라 실행이 안됨
	else: #총으로 인한 애니메이션
		for pieces: RigidBody3D in self.get_children():
			if pieces is RigidBody3D:
				pieces.apply_impulse(pieces.get_child(0).position* INTENSIFY + Vector3(1, 0, 0) * INTENSIFY, self.global_position)
		
	await get_tree().create_timer(2).timeout
	queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for pieces: RigidBody3D in self.get_children():
		if pieces is RigidBody3D:
			pieces.apply_impulse(Vector3(0, gravity_strength * delta, 0), Vector3.ZERO)
