extends Node2D
onready var start_node = $'StartTime'
var processing_history = []
const LINE_MAX_HEIGHT = 40.0
var usecs_finish = 0

export var ENABLED:bool = false

func _ready() -> void:
	if !ENABLED:
		set_process(false)
		
	for i in range (960):
		processing_history.append(0)

func _process(delta: float) -> void:
	usecs_finish = OS.get_ticks_usec()
	var frame_usecs = usecs_finish - start_node.usecs
	processing_history.append(frame_usecs)
	processing_history.remove(0)
	update()
	
func _draw() -> void:
	if !ENABLED:
		return
	""" 
	This is an expensive draw operation
	Only useful for debugging purposes I guess...
	should keep disabled or move it to the GPU. 
	"""
	for i in range (processing_history.size()):
		var ratio = processing_history[i] / 16000.0
		var color = Color(1,1,1).darkened(1.0 - ratio)
		#var line_height = min((processing_history[i] / 1000.0) * LINE_MAX_HEIGHT, LINE_MAX_HEIGHT)
		draw_line(Vector2(i, 0), Vector2(i, LINE_MAX_HEIGHT), color, 1.0, true)
	
	# This print tells how expensive the draw was.
	#print (OS.get_ticks_usec() - usecs_finish)
