extends Label
var drops:int = 0

func _process(delta: float) -> void:
	if delta > 0.017:
		drops += 1
		text = str(drops) + ' drops'
