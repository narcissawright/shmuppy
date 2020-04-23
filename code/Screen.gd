extends Node2D
var fine_position:Vector2 = position
var ui_offset = Vector2(0,40)
var bounds = Rect2((ui_offset), Vector2(960, 500))

func has(point:Vector2, grow_amount:float = 0) -> bool:
	bounds.position = global_position + ui_offset
	
	# hardcoded offscreen limit for objects
	if bounds.grow(grow_amount).has_point(point):
		return true
	return false

func _ready() -> void:
	Events.connect('player_defeated', self, '_on_player_defeated')

func _physics_process(delta: float) -> void:
	fine_position += Game.player.screen_velocity
	# keep all sprites 1:1 size
	position = fine_position.round()

func _on_player_defeated() -> void:
	set_physics_process(false)
