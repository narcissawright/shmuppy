extends Node2D

const PROJECTILE_VELOCITY = 5.0
const SHOT_FREQUENCY = 10

var framecount:int = 0
var projectile = preload("res://Projectile.tscn")

var time_elapsed = 0.0

func _process(t: float) -> void:
	time_elapsed += t
	framecount += 1
	if framecount > SHOT_FREQUENCY:
		framecount -= SHOT_FREQUENCY
		shoot()
		
	position += Vector2.UP.rotated(time_elapsed)
	
func shoot():
	var p = projectile.instance()
	
	# calculates leading shots. "the octorok algo"
	var angle_1 = Game.player.position - position
	var dist_1 = angle_1.length()
	var pos_2 = Game.player.position + Game.player.velocity
	var angle_2 = pos_2 - position
	var dist_2 = angle_2.length() - PROJECTILE_VELOCITY
	var dist_diff = dist_1 - dist_2
	var steps = dist_1 / dist_diff
	if steps > 0:
		var projected_pos = Game.player.position + (Game.player.velocity * steps)
		projected_pos.x = clamp(projected_pos.x, Game.screen_bounds.position.x + 10.0, Game.screen_bounds.end.x - 10.0)
		projected_pos.y = clamp(projected_pos.y, Game.screen_bounds.position.y + 10.0, Game.screen_bounds.end.y - 10.0)
		var win_angle = (projected_pos - position).normalized()
		p.velocity = win_angle * PROJECTILE_VELOCITY
	else:
		p.velocity = angle_1.normalized() * PROJECTILE_VELOCITY
	
	p.radius = 3.0
	p.color = Color(1,0.2,0.2)
	p.seek_amount = 0.0
	p.position = position
	
	$'../BulletHolder'.add_child(p)
	
