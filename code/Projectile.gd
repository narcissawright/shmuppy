extends Node2D

var radius:float
var color:Color
var seek_amount:float
var velocity:Vector2
var ownership = "enemy" # or "player"
onready var current = $'Area2D/current'
onready var prior = $'Area2D/prior'
onready var rect = $'Area2D/rect'

var lifetime = 0

func _ready() -> void:
	current.shape.radius = radius
	prior.shape.radius = radius
	rect.scale.y = radius
	rect.scale.x = 1.0
	
	if ownership == "player":
		$'enemy_sprite'.hide()
		$'player_sprite'.show()
		$'Area2D'.collision_layer = 1
		$'Area2D'.collision_mask = 2

func _process(t: float) -> void:
	update_hitboxes()
	
	lifetime += 1
	$'Label'.text = str(lifetime)
	
	position += velocity
	
	if not Game.screen.has(position, 100):
		queue_free()
		
func update_hitboxes() -> void:
	prior.position = -velocity
	rect.scale.x = velocity.length() / 2.0
	rect.position = -velocity / 2.0
	rect.rotation = Vector2.RIGHT.angle_to(velocity)
	rect.disabled = false

func _on_Area2D_area_entered(area: Area2D) -> void:
	queue_free()

func _on_Area2D_body_entered(body: Node) -> void:
	if body.collision_layer == Game.collision_layers.wall:
		queue_free()
