tool
extends Polygon2D
export var run_script = true setget make_wall

func make_wall(value):
	print("running wall_builder_tool.gd")
	run_script = !run_script
	
	if Engine.editor_hint:
		
		if not value:
			for n in get_children():
				remove_child(n)
				n.free()
			
		else:
		
			color = Color('793d4a')
			texture = load("res://img/tyr_bg2.png")
			
			for n in get_children():
				remove_child(n)
				n.free()
				
			var line = Line2D.new()
			line.width = 2
			var line_poly = polygon
			line_poly.append(polygon[0])
			line.points = line_poly
			line.default_color = Color('793d4a')
			line.name = "WallLine"
			line.antialiased = true
			line.set_meta("_edit_lock_", true)
			add_child(line)
			line.owner = owner
	
			var staticbody = StaticBody2D.new()
			staticbody.name = 'Wall'
			staticbody.collision_layer = Layers.wall
			staticbody.set_meta("_edit_lock_", true)
			add_child(staticbody)
			staticbody.owner = owner
	
			var collision = CollisionPolygon2D.new()
			collision.polygon = polygon
			collision.name = 'WallCollision'
			collision.set_meta("_edit_lock_", true)
			staticbody.add_child(collision)
			collision.owner = owner
