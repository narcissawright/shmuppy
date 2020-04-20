extends Node2D

const MOVE_SPEED = 3.0
const MOVEMENT_INTERPOLATION = 0.2
const BORDER_SIZE = 10.0

var velocity:Vector2
var damaged = false

func _process(t:float) -> void:
	# Movement
	var move_dir = Game.get_stick_input('left') * MOVE_SPEED
	var thrust_multiplier = 1.0
	if Input.is_action_pressed("thrust"):
		thrust_multiplier = 2.0
	velocity = velocity.linear_interpolate(move_dir * thrust_multiplier, MOVEMENT_INTERPOLATION)
	position += velocity
	position.x = clamp(position.x, Game.screen_bounds.position.x + BORDER_SIZE, Game.screen_bounds.end.x - BORDER_SIZE)
	position.y = clamp(position.y, Game.screen_bounds.position.y + BORDER_SIZE, Game.screen_bounds.end.y - BORDER_SIZE)


func _on_Area2D_area_entered(area: Area2D) -> void:
	damaged = true
