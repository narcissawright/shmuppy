extends Node2D

onready var player = $"Player"
onready var shooter = $"Shooter"
onready var bullet_holder = $'BulletHolder'

func draw_trail(t:Node2D) -> void:
	if t.positions.size() > 1:
		draw_polyline_colors(t.positions, t.colors, t.width, false)

func _draw() -> void:
	
	# Background
	draw_rect(Game.screen_bounds, Color(0,0,0))
	if Game.player.damaged:
		#get_material().set_shader_param("damaged", true)
		draw_rect(Rect2(Vector2.ZERO, Game.screen_bounds.size), Color(0.02,0,0))
		Game.player.damaged = false
	#else:
		#get_material().set_shader_param("damaged", false)
	
	# Player Trail
	if Game.player.has_node('Trail'):
		var t = Game.player.get_node('Trail')
		draw_trail(t)
#
	for p in bullet_holder.get_children():
		if p.has_node('Trail'):
			var t = p.get_node('Trail')
			draw_trail(t)

func _process(t) -> void:
	update()
