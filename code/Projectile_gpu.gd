extends Node2D

var enabled:bool = false
var radius:float
var color:Color
var seek_amount:float
var velocity:Vector2
var ownership:String
var dmg = 25.0
var bullet_index:int

var shape:CircleShape2D
var mask:int = 0
var query:Physics2DShapeQueryParameters

onready var tween = $'Tween'
onready var collision_fx = $'collisionfx'

func _ready() -> void:
	material = material.duplicate()
	set_process(false)

func disable() -> void:
	tween.stop_all()
	collision_fx.emitting = false
	enabled = false
	set_process(false)
	BulletManager.add_to_disabled(bullet_index)
	hide()

func enable() -> void:
	enabled = true
	self.modulate = Color(1,1,1,1)
	show()
	
	match ownership:
		"player":
			mask = Layers.wall | Layers.enemy
		"enemy":
			mask = Layers.wall | Layers.player
	
	shape = CircleShape2D.new()
	query = Physics2DShapeQueryParameters.new()
	
	shape.radius = radius
	
	query.collision_layer = mask
	query.set_shape(shape)
	query.motion = velocity
	query.transform = global_transform
	material.set_shader_param("passed_color",color)
	material.set_shader_param("radius",radius)
	set_process(true)

func _process(t: float) -> void:
	
	material.set_shader_param("velocity",velocity)
	
	if not Game.screen.has(position, 100):
		disable()
		return
	
	query.transform = global_transform
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.cast_motion(query) 
	if result.size() > 0:
		if result[1] == 1:
			# projectile did not hit anything
			position += velocity
		else:
			# projectile hit something
			position += velocity * result[1]
			query.transform = transform
			hit()
	else:
		# projectile cannot move, burst immediately
		hit()

func hit():
	set_process(false)
	collision_fx.activate(velocity)
	#if col.collider.collision_layer & Layers.player == Layers.player:
	#	Game.player.damaged(dmg)
	
	fadeout()
	
func fadeout() -> void:
	tween.interpolate_property(self, "modulate", 
		Color(1,1,1,1), Color(1,1,1,0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
