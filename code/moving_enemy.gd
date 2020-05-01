extends KinematicBody2D
var health:float = 200.0
var velocity:Vector2
var max_speed:float = 100.0
var state = 'disabled'
var target_location:Vector2

func _ready() -> void:
	target_location = $'target_location'.global_position
	
func _physics_process(t:float) -> void:
	#$'Label'.text = state
	match state:
		'disabled':
			if Game.screen.has(global_position, 30):
				state = 'chase_target'
		'chase_target':
			var movedir = (target_location - global_position).normalized()
			velocity = velocity.linear_interpolate(movedir * max_speed, 0.2)
			move_and_slide(velocity)
			despawn_check()
			if (target_location - global_position).length() < 10.0:
				velocity = Vector2.ZERO
				state = 'exit_right'
		'exit_right':
			velocity = velocity.linear_interpolate(Vector2.RIGHT * max_speed, 0.2)
			move_and_slide(velocity)
			despawn_check()

func despawn_check() -> void:
	if not Game.screen.has(global_position, 30):
		queue_free()

func hit(dmg) -> void:
	health -= dmg
	if health <= 0.0:
		Game.player.destroyed += 1
		queue_free()
