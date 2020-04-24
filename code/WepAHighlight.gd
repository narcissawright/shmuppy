extends Label

var unlit = Color('ab85ea')
var lit = Color(1,1,1)

func _process(t:float) -> void:
	if Input.is_action_pressed("shoot"):
		modulate = lit
	else:
		modulate = unlit
