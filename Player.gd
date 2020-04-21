extends Node2D

const MOVE_SPEED = 3.0
const MOVEMENT_INTERPOLATION = 0.2
const BORDER_SIZE = 10.0

var velocity:Vector2
var damaged = false
var energy = 200.0
var shoot_cost = 1.0

var projectile = preload("res://Projectile.tscn")
var fire_rate = 10 # frames per shot
var frame_counter = 0
const PROJECTILE_VELOCITY = 5.0

func _process(t:float) -> void:
	frame_counter += 1
	
	# Movement
	var move_dir = Game.get_stick_input('left') * MOVE_SPEED
	var thrust_multiplier = 1.0
	if Input.is_action_pressed("thrust") && energy > 1.0:
		thrust_multiplier = 2.0
		energy -= 0.3 * move_dir.length()
	velocity = velocity.linear_interpolate(move_dir * thrust_multiplier, MOVEMENT_INTERPOLATION)
	position += velocity
	position.x = clamp(position.x, Game.screen_bounds.position.x + BORDER_SIZE, Game.screen_bounds.end.x - BORDER_SIZE)
	position.y = clamp(position.y, Game.screen_bounds.position.y + BORDER_SIZE, Game.screen_bounds.end.y - BORDER_SIZE)

	if Input.is_action_pressed("shoot") && energy > shoot_cost && frame_counter > 10:
		frame_counter = 0
		energy -= shoot_cost
		shoot()

	if energy < 200.0:
		energy = min (energy + 0.1, 200.0)

func _on_Area2D_area_entered(area: Area2D) -> void:
	damaged = true
	
func shoot() -> void:
	var p = projectile.instance()
	
	var angle_1 = $'../Shooter'.position - position
	p.velocity = angle_1.normalized() * PROJECTILE_VELOCITY
	p.radius = 3.0
	p.position = position
	p.ownership = 'player'
	
	$'../BulletHolder'.add_child(p)
