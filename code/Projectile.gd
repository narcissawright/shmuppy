extends KinematicBody2D

var radius:float
var color:Color
var seek_amount:float
var velocity:Vector2
var ownership = "enemy" # or "player"
var dmg = 25.0
onready var hitbox = $'hitbox'

func _ready() -> void:
	hitbox.shape.radius = radius
	
	match ownership:
		"player":
			$'player_sprite'.show()
			collision_layer = 0
			collision_mask = Layers.wall | Layers.enemy
		"enemy":
			$'enemy_sprite'.show()
			collision_layer = 0
			collision_mask = Layers.wall | Layers.player

func _physics_process(t: float) -> void:
	
	if not Game.screen.has(position, 100):
		queue_free()
		return
		
	var collision = move_and_collide(velocity)
	if collision:
		set_physics_process(false)
		hit(collision)
		
func hit(col):
	if col.collider.collision_layer & Layers.player == Layers.player:
		Game.player.damaged(dmg)
	yield(VisualServer, 'frame_post_draw')
	queue_free()
