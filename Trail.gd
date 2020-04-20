extends Node2D
var parent
var data = []
export var color := Color(0.4,0,2)
export var width:float = 3.0

func _ready() -> void:
	parent = get_parent()

func _process(delta: float) -> void:
	data.append(parent.global_position)
	if data.size() > Game.MAX_TRAIL_LENGTH:
		data.remove(0)
