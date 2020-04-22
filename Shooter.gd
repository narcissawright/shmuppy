extends Node2D

const PROJECTILE_VELOCITY = 5.0
const SHOT_FREQUENCY = 10

var framecount:int = 0
var projectile = preload("res://Projectile.tscn")

var time_elapsed = 0.0
var leading_shot_velocity = Vector2.ZERO
var draw_position = Vector2.ZERO


func _process(t: float) -> void:
	time_elapsed += t
	framecount += 1
	
	#calc_leading_shot_velocity()
	
	if framecount > SHOT_FREQUENCY:
		framecount -= SHOT_FREQUENCY
		shoot()
		
	#position += Vector2.UP.rotated(time_elapsed)

func calc_leading_shot_velocity() -> Vector2:

	""" YAK CALC"""

#	var SELF_TO_PLAYER = Game.player.position - self.position
#	"""
#	pow(time * Game.player.velocity.length(),2) == 
#		pow(SELF_TO_PLAYER.length(),2) + 
#		pow(PROJECTILE_VELOCITY * time,2) - 
#		2 * SELF_TO_PLAYER.length() * 
#		(PROJECTILE_VELOCITY * time) * dotproduct
#	"""
#
#	var L = SELF_TO_PLAYER.length()
#	var P = Game.player.velocity.length()
#	var S = PROJECTILE_VELOCITY
#	var dot = Game.player.velocity.normalized().dot(SELF_TO_PLAYER.normalized())
#	var t = 0.0
#
#	if P != S:
#		var part1 = sqrt(pow(L,2) * ((pow(dot,2)) * pow(S,2) + pow(P,2)))
#		var part2 = dot * L * S
#		var upper = part1 + part2
#		var bottom = pow(P,2) - pow(S,2)
#		t = -(upper / bottom)
#	elif (2 * dot * S) != 0:
#		t = L / (2 * dot * S)

	""" NARCISSA CALC """

#	var a = Game.player.position - self.position
#
#	var a_dist = a.length()
#
#	var pos_2 = Game.player.position + Game.player.velocity
#	var b = pos_2 - self.position
#	var b_dist = b.length() - PROJECTILE_VELOCITY
#	var comparison_1 = a_dist - b_dist
#
#	var pos_3 = pos_2 + Game.player.velocity
#	var c = pos_3 - self.position
#	var c_dist = c.length() - (PROJECTILE_VELOCITY * 2.0)
#	var comparison_2 = b_dist - c_dist
#
#	var rate_of_change = comparison_1 - comparison_2
##	var t = 0
##	if rate_of_change != 0:
##		t = (comparison_1 - a_dist) / rate_of_change
#
#	var t = a_dist / comparison_1


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
		return shoot_direction
	   
		# Improvement: if impact point is out of bounds it might as well be no solution
		impact_point = shooter_location + shoot_direction * time_to_hit
	else: # fallback to shooting straight ahead
		shoot_direction = target_location - shooter_location
		return shoot_direction.normalized() * projectile_speed


	""" HWAN CALC """
#	var a = Game.player.position - self.position
#	var L = a.length()
#	var P = Game.player.velocity.length()
#	var S = PROJECTILE_VELOCITY
#	var D = Game.player.velocity.normalized().dot(a.normalized())
#
#	var term1 = D * L * P
#	var term2 = sqrt((L*L) * ( ((D*D) - 1.0) * (P*P) + (S*S) ))
#	var term3 = (P*P) - (S*S)
#
#	var t = 0.0
#
#
#	if P != S:
#		var t1 = (term1 - term2) / term3
#		var t2 = (term1 + term2) / term3
#
#		$'Label'.text = str("t1: ", t1, "  t2: ", t2)
#
#		t = min(t1, t2)
#		if t < 0:
#			t = max(t1, t2)
#
#	if P == S && D*L*S != 0:
#		t = L / (2 * D * S)
#	$'Label'.text += str("   t: ", t)


#	if t > 0:
#		var projected_pos = Game.player.position + (Game.player.velocity * t)
#		projected_pos.x = clamp(projected_pos.x, Game.screen_bounds.position.x + 10.0, Game.screen_bounds.end.x - 10.0)
#		projected_pos.y = clamp(projected_pos.y, Game.screen_bounds.position.y + 10.0, Game.screen_bounds.end.y - 10.0)
#		draw_position = projected_pos
#		var win_angle = (projected_pos - self.position).normalized()
#		return (win_angle * PROJECTILE_VELOCITY)
#	else:
#		return (a.normalized() * PROJECTILE_VELOCITY)

#func _draw() -> void:
#	draw_line(Vector2.ZERO, draw_position - self.position, Color(0.5, 0, 0.5), 2.0, true)

func shoot():
	var p = projectile.instance()
	
	p.velocity = calc_leading_shot_velocity()
	
	# calculates leading shots. "the octorok algo"
#	var angle_1 = Game.player.position - position
#	var dist_1 = angle_1.length()
#	var pos_2 = Game.player.position + Game.player.velocity
#	var angle_2 = pos_2 - position
#	var dist_2 = angle_2.length() - PROJECTILE_VELOCITY
#	var dist_diff = dist_1 - dist_2
#	var steps = dist_1 / dist_diff
#	if steps > 0:
#		var projected_pos = Game.player.position + (Game.player.velocity * steps)
#		projected_pos.x = clamp(projected_pos.x, Game.screen_bounds.position.x + 10.0, Game.screen_bounds.end.x - 10.0)
#		projected_pos.y = clamp(projected_pos.y, Game.screen_bounds.position.y + 10.0, Game.screen_bounds.end.y - 10.0)
#		var win_angle = (projected_pos - position).normalized()
#		p.velocity = win_angle * PROJECTILE_VELOCITY
#	else:
#		p.velocity = angle_1.normalized() * PROJECTILE_VELOCITY
	
	p.radius = 3.0
	p.color = Color(1,0.2,0.2)
	p.seek_amount = 0.0
	p.position = position
	
	$'../BulletHolder'.add_child(p)
	
