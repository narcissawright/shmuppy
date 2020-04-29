extends Node2D

const PROJECTILE_VELOCITY = 7.5
const SHOT_FREQUENCY = 30

export var draw = false

var framecount:int = 0

var energy = 200.0

var time_elapsed = 0.0
var draw_impact_point = Vector2()
var velocity = Vector2(0.2, 0)

func _ready() -> void:
	Events.connect('player_defeated', self, '_on_player_defeated')
	
func _on_player_defeated():
	set_physics_process(false)

func _physics_process(t: float) -> void:
	if Game.screen.has(global_position, 10):
		time_elapsed += t
		framecount += 1
		if framecount > SHOT_FREQUENCY:
			framecount -= SHOT_FREQUENCY
			shoot()
		if draw:
			update()
		#position += velocity

func _draw():
	if draw:
		draw_line(Vector2.ZERO, draw_impact_point - position, Color(0.5,0,0.5), 2, true)

func shoot():
	
	var shot_information = {
		'shooter_location': global_position,
		'shooter_velocity': Vector2.ZERO,
		'projectile_speed': PROJECTILE_VELOCITY,
		'target_location' : Game.player.global_position,
		'target_velocity' : Game.player.velocity + Game.player.screen_velocity
	}
	var p_data:Dictionary = {
		'velocity' : Game.calc_leading_shot_velocity(shot_information),
		'radius' : 3.0,
		'color' : Color(0.2,0.7,0.1),
		'seek_amount' : 0.0,
		'ownership' : 'enemy',
		'position' : position
	}
	BulletManager.spawn_bullet(p_data)
	
	#var p = projectile.instance()
#	p.velocity = Game.calc_leading_shot_velocity(shot_information)
#	p.radius = 3.0
#	p.color = Color(0.2,0.5,0.1)
#	p.seek_amount = 0.0
#	p.position = position
#	Game.bullet_holder.add_child(p)
	
