extends Node

func _process(delta: float) -> void:
	var usecs_finish = OS.get_ticks_usec()
	var start_node = $'../Start'
	var frame_usecs = usecs_finish - start_node.usecs
	var ms = round(frame_usecs / 10.0) / 100.0
	#print ("gdscript frame time: ", str(ms), 'ms')
