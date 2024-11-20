extends Label
#tween.parallel().tween_property($texture_start_btn, "modulate", Color(1, 1, 1, 1), 1.0)

func _ready():
	# 점점 투명해지면서 사라지기
	var tween = create_tween()
	tween.parallel().tween_property(self, "modulate", Color(0.01, 0.98, 0.17, 0), 0.5)
	tween.parallel().tween_property(self, "position:y", position.y - 100, 0.5)
	# 1초 후 Label 노드 삭제
	tween.tween_callback(self.queue_free)
