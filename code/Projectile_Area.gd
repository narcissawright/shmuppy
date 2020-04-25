extends Area2D 

var radius:float
var color:Color
var seek_amount:float
var velocity:Vector2
var ownership = "enemy" # or "player"
onready var current = $'current'
onready var prior = $'prior'
onready var rect = $'rect'

#var lifetime = 0

func _ready() -> void:
	current.shape.radius = radius
	prior.shape.radius = radius
	rect.scale.y = radius
	rect.scale.x = 1.0
	
	match ownership:
		"player":
			$'main_sprites/player_sprite'.show()
			collision_layer = 0
			collision_mask = Layers.wall | Layers.enemy
		"enemy":
			$'main_sprites/enemy_sprite'.show()
			collision_layer = 0
			collision_mask = Layers.wall | Layers.player

func _process(t: float) -> void:
	update_hitboxes()
	
	#lifetime += 1
	#$'Label'.text = str(lifetime)
	
	position += velocity
	
	if not Game.screen.has(position, 100):
		queue_free()
		
func update_hitboxes() -> void:
	prior.position = -velocity
	rect.scale.x = velocity.length() / 2.0
	rect.position = -velocity / 2.0
	rect.rotation = Vector2.RIGHT.angle_to(velocity)
	rect.disabled = false

#func _on_Area2D_area_entered(area: Area2D) -> void:
#	queue_free()
#
#func _on_Area2D_body_entered(body: Node) -> void:
#	if body.collision_layer == Game.collision_layers.wall:
#		queue_free()


func _on_Projectile_body_entered(body: Node) -> void:
	set_process(false)
	hit(body)
		
func hit(col):
	collision_layer = 0
	collision_mask = 0
	$'collisionfx'.activate(velocity)
	if col.collision_layer & Layers.player == Layers.player:
		Game.player.damaged(25.0)

	var tween = get_node("Tween")
	tween.interpolate_property($'main_sprites', "modulate", 
		Color(1,1,1,1), Color(1,1,1,0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

