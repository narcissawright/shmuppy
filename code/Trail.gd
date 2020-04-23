extends Line2D
var parent
var positions = []
const MAX_TRAIL_LENGTH = 10

func _ready() -> void:
	parent = get_parent()
	width = parent.radius * 2
	gradient = Gradient.new()
	gradient.set_color(0, Color(0,0,0,0))
	gradient.set_color(1, parent.color)
	for i in range (MAX_TRAIL_LENGTH):
		positions.append(parent.global_position)

func _process(delta: float) -> void:
	positions.append(parent.global_position)
	positions.remove(0)
	
	var positions_local = []
	for i in (positions.size()):
		positions_local.append(positions[i] - global_position)
	points = PoolVector2Array(positions_local)
