extends Node

var joyID:int = 0
var player:KinematicBody2D
var topbar = preload("res:///scenes/TopBar.tscn")
var topbar_height = 40.0
var screen

func _ready() -> void:
	topbar = topbar.instance()
	add_child(topbar)

	screen = load("res:///scenes/ScreenBounds.tscn").instance()
	add_child(screen)
	player = $'ScreenBounds/Player'
	player.z_index = 2
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	for i in range (Input.get_connected_joypads().size()):
		print(i, ": ", Input.get_joy_name(i))
		if Input.get_joy_name(i) == 'XInput Gamepad':
			joyID = i
	print ("Set primary joystick to ID ", joyID)
	get_viewport().render_target_clear_mode = 0

func _input(e) -> void:
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func get_movement_input() -> Vector2:
	var move_dir := Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		move_dir.y -= 1
	if Input.is_action_pressed("down"):
		move_dir.y += 1
	if Input.is_action_pressed("left"):
		move_dir.x -= 1
	if Input.is_action_pressed("right"):
		move_dir.x += 1
		
	if move_dir != Vector2.ZERO:
		move_dir = move_dir.normalized()
	else:
		move_dir = get_stick_input('left')
	return move_dir

func get_stick_input(which:String) -> Vector2:
	var axes = Vector2()
	if which == "left":
		axes = Vector2(Input.get_joy_axis(joyID, 0), Input.get_joy_axis(joyID, 1))
	elif which == "right":
		axes = Vector2(Input.get_joy_axis(joyID, 2), Input.get_joy_axis(joyID, 3))
	var length:float = axes.length_squared()
	if length > 0.88:
		return axes.normalized()
	elif length < 0.015:
		return Vector2()
	axes = axes*axes.abs() # easing
	return axes

func calc_leading_shot_velocity(shot_info:Dictionary) -> Vector2:

	# shot_info contains: 
	# shooter_location : Vector2
	# shooter_velocity : Vector2
	# projectile_speed : float
	# target_location  : Vector2
	# target_velocity  : Vector2
	
	# Currently, shooter_velocity is not accounted for
	# so it is possible to "outrun" your shots
	
	# thank you Glace
	# https://www.hansenlabs.com/wp-content/uploads/2018/02/target-leading-2d.pdf
   
	# What we want to know...
	var shoot_direction: Vector2 # ai + bj
	var impact_point: Vector2 # Xi, Yi
	var time_to_hit: float # t
   
	# ?????
	var A = pow(shot_info.target_velocity.x, 2.0) + pow(shot_info.target_velocity.y, 2.0) - pow(shot_info.projectile_speed, 2.0)
	var B = 2 * shot_info.target_velocity.x * (shot_info.target_location.x - shot_info.shooter_location.x) + 2 * shot_info.target_velocity.y * (shot_info.target_location.y - shot_info.shooter_location.y)
	var C = pow(shot_info.target_location.x - shot_info.shooter_location.x, 2.0) + pow(shot_info.target_location.y - shot_info.shooter_location.y, 2.0)
	
	var solution_exists = true
	
	var first_time_to_hit = (-B + sqrt((B*B) - 4 * A * C)) / (2 * A)
	var second_time_to_hit = (-B - sqrt((B*B) - 4 * A * C)) / (2 * A)
	time_to_hit = min(first_time_to_hit, second_time_to_hit)
	if sign(time_to_hit) < 1:
		time_to_hit = max(first_time_to_hit, second_time_to_hit)
		if sign(time_to_hit) < 1:
			solution_exists = false

	if solution_exists:
		shoot_direction.x = ((shot_info.target_location.x - shot_info.shooter_location.x) / time_to_hit) + shot_info.target_velocity.x
		shoot_direction.y = ((shot_info.target_location.y - shot_info.shooter_location.y) / time_to_hit) + shot_info.target_velocity.y
		
		# Improvement: if impact point is out of bounds it might as well be no solution
		impact_point = shot_info.shooter_location + shoot_direction * time_to_hit
		
		return shoot_direction
		
	else: # fallback to shooting straight ahead
		shoot_direction = shot_info.target_location - shot_info.shooter_location
		return shoot_direction.normalized() * shot_info.projectile_speed
