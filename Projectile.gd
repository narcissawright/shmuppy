extends Node2D

var radius:float
var color:Color
var seek_amount:float
var velocity:Vector2

func _ready() -> void:
	$'Area2D/CollisionShape2D'.shape.radius = radius

func _process(t: float) -> void:
	position += velocity
	if !Game.screen_bounds.grow(200.0).has_point(global_position):
		queue_free()
		
