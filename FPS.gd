extends Label
var elapsed = 0.0

func _process(delta: float) -> void:
	elapsed += delta
	if elapsed > 2.0:
		text = str(Engine.get_frames_per_second()) + ' FPS'
