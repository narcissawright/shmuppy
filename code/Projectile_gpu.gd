extends Node2D

var state:String = 'disabled' # 'enabled', 'hit'
var radius:float
var color:Color
var seek_amount:float # unused
var velocity:Vector2
var ownership:String # 'player', 'enemy'
var bullet_index:int # index for BulletManager

var shape:CircleShape2D
var mask:int = 0 # which layers are we checking for collisions
var query:Physics2DShapeQueryParameters

onready var collision_fx = $'collisionfx'

func _ready() -> void:
	material = material.duplicate()
	set_process(false)

func disable() -> void:
	collision_fx.emitting = false
	state = 'disabled'
	set_process(false)
	BulletManager.add_to_disabled(bullet_index)
	hide()

func enable() -> void:
	state = 'enabled'
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
	# maybe set texture size here....
	
	material.set_shader_param("passed_color",color)
	material.set_shader_param("radius",radius)
	material.set_shader_param("velocity",velocity)
	set_process(true)

func _process(t: float) -> void:
	
	# doesn't need to be set in process 
	# due to velocity remaining constant so far
	# material.set_shader_param("velocity",velocity)
	
	match state:
		'enabled':
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
					material.set_shader_param("velocity", velocity * result[1])
					query.transform = transform
					hit(space_state)
			else:
				# projectile cannot move, burst immediately
				material.set_shader_param("velocity",0.0)
				hit(space_state)
		'hit':
			material.set_shader_param("velocity",0.0)
			radius = radius * 0.92
			material.set_shader_param("radius",radius)

func hit(space_state):
	state = 'hit'
	collision_fx.activate(velocity)
	
	var collisions = space_state.intersect_shape(query)
	
	for i in range (collisions.size()):
		if not collisions[i].collider.collision_layer & Layers.wall == Layers.wall:
			# if not wall, send hit
			collisions[i].collider.hit(20.0)
