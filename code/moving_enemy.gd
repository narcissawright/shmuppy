extends KinematicBody2D
var health:float = 200.0
var velocity := Vector2(-150, 0)
var state = 'disabled'

func _physics_process(t:float) -> void:
	match state:
		'disabled':
			if Game.screen.has(global_position, 30):
				state = 'active'
		'active':
			velocity = move_and_slide(velocity)
			velocity += Vector2(0.75, 0.05)
			if not Game.screen.has(global_position, 30):
				queue_free()

func hit(dmg) -> void:
	health -= dmg
	if health <= 0.0:
		queue_free()
