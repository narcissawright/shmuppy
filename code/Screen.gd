extends Node2D
var fine_position:Vector2 = position
var ui_offset = Vector2(0,40)
var bounds = Rect2((ui_offset), Vector2(960, 500))
var velocity:Vector2

func has(point:Vector2, grow_amount:float = 0) -> bool:
	bounds.position = global_position + ui_offset
	if bounds.grow(grow_amount).has_point(point):
		return true
	return false

func _ready() -> void:
	Events.connect('player_defeated', self, 'stop_scrolling')
	Events.connect('level_complete', self, 'stop_scrolling')

func _process(delta: float) -> void:
	position += velocity
	
	# might not even need to do this every frame
	if not has(Game.player.global_position, 0.0):
		Game.player.die()

func stop_scrolling() -> void:
	set_process(false)
