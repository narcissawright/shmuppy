extends Node2D

var radius:float
var color:Color
var seek_amount:float
var velocity:Vector2
var ownership = "enemy" # or "player"

func _ready() -> void:
	$'Area2D/CollisionShape2D'.shape.radius = radius
	if ownership == "player":
		$'enemy_sprite'.hide()
		$'player_sprite'.show()
		$'Area2D'.collision_layer = 1
		$'Area2D'.collision_mask = 2

func _process(t: float) -> void:
	position += velocity
	if !Game.screen_bounds.grow(200.0).has_point(global_position):
		queue_free()
		
