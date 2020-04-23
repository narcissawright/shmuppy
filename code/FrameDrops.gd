extends Label
var drops:int = 0

func _process(delta: float) -> void:
	drops += round(delta / 0.016667) - 1
	text = str(drops) + ' drops'
