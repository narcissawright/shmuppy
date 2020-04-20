extends Node2D

var orbiters = []

const ORBIT_WIDTH = 3.0
const ORBIT_OFFSET_LENGTH = 20.0
const ORBIT_COLOR = Color(0.4,0,2)

func spawn_orbiter(color):
	orbiters.append({
		"color": color,
		"position": Vector2(),
		"priors": [],
		"offset": Vector2()
	})

#	# Orbit Trails
#	for i in range (Game.MAX_TRAIL_LENGTH - 1):
#		for j in range (orbiters.size()):
#			var darken_amount = 1 - (i / Game.MAX_TRAIL_LENGTH)
#			var i_trail_color = orbiters[j].color.darkened(darken_amount)
#			draw_line(orbiters[j].priors[i], orbiters[j].priors[i+1], i_trail_color, ORBIT_WIDTH, true)
#	for j in range (orbiters.size()):
#		draw_line(orbiters[j].priors.back(), orbiters[j].position, orbiters[j].color, ORBIT_WIDTH, true)

#	for i in range (orbiters.size()):
#		draw_circle(orbiters[i].position.round(), 3.0, orbiters[i].color.lightened(0.5))


#	time_elapsed += t * 5.0
#	time_elapsed = fmod(time_elapsed, TAU)
#
#	for i in range (orbiters.size()):
#		var custom_offset = i * (TAU / orbiters.size())
#		orbiters[i].offset = Vector2.UP.rotated(time_elapsed + custom_offset) * ORBIT_OFFSET_LENGTH
#		orbiters[i].priors.append(orbiters[i].position)
#		orbiters[i].priors.remove(0)
#		orbiters[i].position = player.position + orbiters[i].offset

func rotation_unused():
	# rotation (unused)
	var rotate_dir = Game.get_stick_input('right')
	var rotation_magnitude = rotate_dir.length()
	var target_radians = rotate_dir.angle() + (PI / 2.0)
	# avoid the target radians being > PI
	# target should never be > 180 degrees.
	if abs(Game.player.rotation - target_radians) > PI:
		if Game.player.rotation - target_radians > 0:
			target_radians += TAU
		else:
			target_radians -= TAU
	Game.player.rotation = lerp(Game.player.rotation, target_radians, rotation_magnitude * 0.05)
	# keep it in range 0 to 2PI, or 0-360 degrees
	Game.player.rotation = fmod(Game.player.rotation, TAU)
