extends Node
var usecs:int = 0

func _process(delta: float) -> void:
	usecs = OS.get_ticks_usec()
