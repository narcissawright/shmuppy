extends Node2D

onready var player = $"Player"
onready var shooter = $"Shooter"

func draw_trail(t:Node2D) -> void:
	if t.data.size() > 1:
		for i in range (t.data.size() - 1):
			var darken_amount = 1.0 - (i / float(Game.MAX_TRAIL_LENGTH))
			var i_color = t.color.darkened(darken_amount)
			draw_line(t.data[i], t.data[i+1], i_color, t.width, true)

func _draw() -> void:
	
	# Background
	draw_rect(Rect2(Vector2.ZERO, Game.screen_bounds.size), Color(0,0,0))
	if Game.player.damaged:
		get_material().set_shader_param("damaged", true)
		#draw_rect(Rect2(Vector2.ZERO, Game.screen_bounds.size), Color(0.5,0,0))
		Game.player.damaged = false
	else:
		get_material().set_shader_param("damaged", false)
	
	# Player Trail
	if Game.player.has_node('Trail'):
		var t = Game.player.get_node('Trail')
		draw_trail(t)
#
#	for p in shooter.get_children():
#		if p.has_node('Trail'):
#			var t = p.get_node('Trail')
#			draw_trail(t)
#		draw_circle(p.global_position.round(), p.radius, p.color)
		
	# Shooter
#	draw_circle(shooter.global_position.round(), 5.0, Color(1,0.2,0.2))
#
#	# Player
#	draw_circle(Game.player.position.round(), 5.0, Color(1,1,1))

func _process(t) -> void:
	update()
	$'debug_label'.text = str(Engine.get_frames_per_second()) + ' FPS'
