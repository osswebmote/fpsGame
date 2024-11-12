extends Label

@onready var root = get_tree().current_scene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text = str(root.get_score())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.text = str(root.get_score())
	pass
