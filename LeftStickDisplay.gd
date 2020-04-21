extends Sprite

func _process(delta: float) -> void:
	var pos = Game.get_stick_input("left")
	if pos.is_normalized():
		get_parent().frame = 1
	else:
		get_parent().frame = 0
	position = pos * 12.0
