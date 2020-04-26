extends Node2D

var radius:float
var color:Color
var seek_amount:float
var velocity:Vector2
var ownership = "enemy" # or "player"
var dmg = 25.0

var shape:CircleShape2D
var mask:int = 0
var query:Physics2DShapeQueryParameters

func _ready() -> void:
	
	match ownership:
		"player":
			$'main_sprites/player_sprite'.show()
			mask = Layers.wall | Layers.enemy
		"enemy":
			$'main_sprites/enemy_sprite'.show()
			mask = Layers.wall | Layers.player
	
	shape = CircleShape2D.new()
	shape.radius = radius
	
	query = Physics2DShapeQueryParameters.new()
	query.collision_layer = mask
	query.set_shape(shape)
	query.motion = velocity

func _process(t: float) -> void:
	
	if not Game.screen.has(position, 100):
		queue_free()
		return
	
	query.transform = global_transform
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.cast_motion(query) 
	if result.size() > 0:
		if result[1] == 1:
			position += velocity
		else:
			position += velocity * result[1]
			query.transform = transform
			hit()
	else:
		hit()

func hit():
	set_process(false)
	$'collisionfx'.activate(velocity)
	#if col.collider.collision_layer & Layers.player == Layers.player:
	#	Game.player.damaged(dmg)
	var tween = get_node("Tween")
	tween.interpolate_property($'main_sprites', "modulate", 
		Color(1,1,1,1), Color(1,1,1,0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
