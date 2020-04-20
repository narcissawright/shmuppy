extends Node2D

const PROJECTILE_VELOCITY = 5.0
const SHOT_FREQUENCY = 10

var framecount:int
var projectile = preload("res://Projectile.tscn")


func _process(t: float) -> void:
	framecount += 1
	if framecount > SHOT_FREQUENCY:
		framecount -= SHOT_FREQUENCY
		shoot()
	
func shoot():
	var p = projectile.instance()
	
	var direct_line = (position - Game.player.position).normalized()
	var actual_line = Game.player.velocity.normalized()
	var interp_amount = abs(direct_line.dot(actual_line))
	# if interp_amount is 1 or very close to 1 then no leading is required.
	# if player velocity is 0 or very close to 0 then no leading is required.
	
	
	# fix this mess
	var time_distance = position.distance_to(Game.player.position) / PROJECTILE_VELOCITY
	var projected_position = Game.player.position + (Game.player.velocity * time_distance)
	var lead_dir = (projected_position - position).normalized()
	var dummy_dir = (Game.player.position - position).normalized()
	p.velocity = lead_dir.linear_interpolate(dummy_dir, interp_amount).normalized() * PROJECTILE_VELOCITY
	
	p.radius = 3.0
	p.color = Color(1,0.2,0.2)
	p.seek_amount = 0.0
	p.position = Vector2.ZERO
	
	add_child(p)
	
