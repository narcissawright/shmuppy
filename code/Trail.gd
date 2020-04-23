extends Node2D
var parent
var positions = PoolVector2Array()
var colors = PoolColorArray()
export var width:float = 3.0

func _ready() -> void:
	parent = get_parent()
	for i in range (Game.MAX_TRAIL_LENGTH):
		var darken_amount = 1.0 - (i / float(Game.MAX_TRAIL_LENGTH))
		colors.append(parent.color.darkened(darken_amount))
		positions.append(parent.global_position)

func _process(delta: float) -> void:
	positions.append(parent.global_position)
	positions.remove(0)
	update()
	
func _draw() -> void:
	draw_set_transform(-global_position, 0.0, Vector2(1,1))
	if positions.size() > 1:
		draw_polyline_colors(positions, colors, width, false)
