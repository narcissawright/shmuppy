extends KinematicBody2D
var energy:float = 200.0
var velocity:float = 1.6
var max_speed:float = 100.0
var state = 'disabled'
var target_location:Vector2
onready var pathfollow = get_parent()

func _physics_process(t:float) -> void:
	match state:
		'disabled':
			if Game.screen.has(global_position, 30):
				state = 'enabled'
		'enabled':
			pathfollow.offset += velocity
			if pathfollow.offset > 460.0:
				velocity += 0.03
				despawn_check()

func despawn_check() -> void:
	if not Game.screen.has(global_position, 30):
		queue_free()

func hit(dmg) -> void:
	energy -= dmg
	if energy <= 0.0:
		Game.player.destroyed += 1
		queue_free()
