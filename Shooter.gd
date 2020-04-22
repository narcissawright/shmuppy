extends Node2D

const PROJECTILE_VELOCITY = 5.0
const SHOT_FREQUENCY = 10

export var draw = false

var framecount:int = 0
var projectile = preload("res://Projectile.tscn")

var time_elapsed = 0.0
var draw_impact_point = Vector2()

func _process(t: float) -> void:
	time_elapsed += t
	framecount += 1
	
	if framecount > SHOT_FREQUENCY:
		framecount -= SHOT_FREQUENCY
		shoot()
		
	#position += Vector2.UP.rotated(time_elapsed)
	if draw:
		update()

func calc_leading_shot_velocity() -> Vector2:
	""" GLACE CALC """
	# https://www.hansenlabs.com/wp-content/uploads/2018/02/target-leading-2d.pdf

	# What we know...
	var shooter_location = position            # Xs, Ys
	var target_location = Game.player.position # Xt, Yt
	var target_velocity = Game.player.velocity # ci + dj
	var projectile_speed = PROJECTILE_VELOCITY # P
   
	# What we want to know...
	var shoot_direction: Vector2 # ai + bj
	var impact_point: Vector2 # Xi, Yi
	var time_to_hit: float       # t
   
	# ?????
	var A = pow(target_velocity.x, 2.0) + pow(target_velocity.y, 2.0) - pow(projectile_speed, 2.0)
	var B = 2 * target_velocity.x * (target_location.x - shooter_location.x) + 2 * target_velocity.y * (target_location.y - shooter_location.y)
	var C = pow(target_location.x - shooter_location.x, 2.0) + pow(target_location.y - shooter_location.y, 2.0)
	
	var solution_exists = true
	
	var first_time_to_hit = (-B + sqrt((B*B) - 4 * A * C)) / (2 * A)
	var second_time_to_hit = (-B - sqrt((B*B) - 4 * A * C)) / (2 * A)
	time_to_hit = min(first_time_to_hit, second_time_to_hit)
	if sign(time_to_hit) < 1:
		time_to_hit = max(first_time_to_hit, second_time_to_hit)
		if sign(time_to_hit) < 1:
			solution_exists = false

	if solution_exists:
		shoot_direction.x = ((target_location.x - shooter_location.x) / time_to_hit) + target_velocity.x
		shoot_direction.y = ((target_location.y - shooter_location.y) / time_to_hit) + target_velocity.y
		
		# Improvement: if impact point is out of bounds it might as well be no solution
		impact_point = shooter_location + shoot_direction * time_to_hit
		draw_impact_point = impact_point
		
		return shoot_direction
		
	else: # fallback to shooting straight ahead
		shoot_direction = target_location - shooter_location
		return shoot_direction.normalized() * projectile_speed

func _draw():
	if draw:
		draw_line(Vector2.ZERO, draw_impact_point - position, Color(0.5,0,0.5), 2, true)

func shoot():
	var p = projectile.instance()
	p.velocity = calc_leading_shot_velocity()
	p.radius = 3.0
	p.color = Color(1,0.2,0.2)
	p.seek_amount = 0.0
	p.position = position
	$'../BulletHolder'.add_child(p)
	
