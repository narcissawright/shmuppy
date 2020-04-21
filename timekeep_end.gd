extends Node2D
onready var start_node = $'StartTime'
onready var process_label = $'ProcessLabel'
var processing_history = []
const LINE_MAX_HEIGHT = 40.0
var usecs_finish = 0

var average_size:int = 10
var frame_average:Array = []
var frame_counter:int = 0

export var visualization_enabled:bool = false

func _ready() -> void:
	if visualization_enabled:
		for i in range (960):
			processing_history.append(0)

func _process(delta: float) -> void:
	# Obtain the amount of usecs it took for all nodes to complete.
	# This is obtainable thanks to node.process_priority
	usecs_finish = OS.get_ticks_usec()
	var frame_usecs = usecs_finish - start_node.usecs
	
	# find the average over the last ten frames
	frame_average.append(frame_usecs)
	if frame_average.size() > average_size:
		frame_average.remove(0)
	frame_counter += 1
	if frame_counter >= average_size:
		frame_counter = 0
		var total_t = 0
		for t in frame_average:
			total_t += t
		total_t /= average_size
		var ms = total_t / 1000.0
		var ms_string:String = str(ms).pad_zeros(1).pad_decimals(1) + " ms"
		process_label.text = ms_string
		
	if visualization_enabled:
		processing_history.append(frame_usecs)
		processing_history.remove(0)
		update()
	
func _draw() -> void:
	if not visualization_enabled:
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
