extends KinematicBody2D

const MOVE_SPEED = 3.0
const MOVEMENT_INTERPOLATION = 0.2
const BORDER_SIZE = 10.0
export var color := Color(0.4,0.25,1)

var infinite_energy = false

var velocity:Vector2
var damaged = false
var energy = 200.0 setget _set_energy
var energy_max = 200.0
var shoot_cost = 2.0
var radius = 5.0

var projectile = preload("res://scenes/Projectile_gpu.tscn")

var shot_cooldown = 10 # frames per shot
var cooldown_timer = 0
var shots_fired = 0
var destroyed = 0

const PROJECTILE_VELOCITY = 10.0

func hit(dmg) -> void:
	_set_energy(energy - dmg)

func _set_energy(value):
	if not infinite_energy:
		energy = clamp(value, 0.0, energy_max)
		if energy <= 0.0:
			die()
		
func die() -> void:
	energy = 0.0
	set_physics_process(false)
	$'Sprite'.modulate = Color(1,0.2,0.2)
	Events.emit_signal('player_defeated')

func _ready() -> void:
	Events.connect("level_complete", self, 'level_complete')

func level_complete() -> void:
	set_physics_process(false)
	$'Sprite'.modulate = Color(0.5,0.2,1.0)

func _physics_process(t:float) -> void:
	cooldown_timer = min(cooldown_timer + 1, shot_cooldown)
	
	# Movement
	var move_dir:Vector2 = Game.get_movement_input()
	move_dir *= MOVE_SPEED
	
	var thrust_multiplier = 1.0
	var thrust_cost = 0.1 * move_dir.length()
	if Input.is_action_pressed("thrust") && energy > thrust_cost:
		thrust_multiplier = 2.0
		if not infinite_energy:
			energy -= thrust_cost
	
	velocity = velocity.linear_interpolate(move_dir * thrust_multiplier, MOVEMENT_INTERPOLATION)
	var prior_velocity = velocity
	velocity = move_and_slide(velocity * 60) / 60.0

	for i in range (get_slide_count()):
		var c = get_slide_collision(i)
		if c.collider.collision_layer & (Layers.wall | Layers.enemy) > 0:
			var normal = c.normal.dot(c.travel.normalized())
			var dmg = prior_velocity.length() * abs(normal)
			if not infinite_energy: 
				energy -= dmg
				if energy <= 0.0:
					die()
	
	if Input.is_action_pressed("shoot") && energy > shoot_cost && cooldown_timer >= shot_cooldown:
		shoot()

	if energy < energy_max:
		energy = min (energy + 0.1, energy_max)
	
func shoot() -> void:
	cooldown_timer = 0
	if not infinite_energy:
		energy -= shoot_cost
	shots_fired += 1
	
	var p_data:Dictionary = {
		"velocity": Vector2(),
		"position": global_position,
		"ownership": "player",
		"radius": 3.0,
		"color": color
	}

	var aim_type = "forward"
	
	match aim_type:
		"forward":
			p_data.velocity = Vector2.RIGHT * PROJECTILE_VELOCITY;
		
		"2stick":
			var angle_1 = Vector2()
			var right_stick_input = Game.get_stick_input('right')
			if right_stick_input == Vector2.ZERO:
				angle_1 = (velocity + Game.screen.velocity).normalized()
				if angle_1 == Vector2.ZERO:
					angle_1 = Vector2.RIGHT
			else:
				angle_1 = right_stick_input.normalized()
			var shot_velocity = angle_1.normalized() * PROJECTILE_VELOCITY
			shot_velocity += velocity / 2.0
			if shot_velocity.length() < PROJECTILE_VELOCITY:
				shot_velocity = shot_velocity.normalized() * PROJECTILE_VELOCITY
			p_data.velocity = shot_velocity
	
		"automatic":
			var target_node = $'../../../Level/Shooter'
			var shot_information = {
				'shooter_location': global_position,
				'shooter_velocity': velocity + Game.screen.velocity,
				'projectile_speed': PROJECTILE_VELOCITY,
				'target_location' : target_node.global_position,
				'target_velocity' : target_node.velocity
			}
			p_data.velocity = Game.calc_leading_shot_velocity(shot_information)
	
	BulletManager.spawn_bullet(p_data)
