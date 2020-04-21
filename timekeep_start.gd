extends Node
var usecs:int = 0

func _process(delta: float) -> void:
	# due to process_priority, 
	# this runs before all other nodes.
	usecs = OS.get_ticks_usec()
