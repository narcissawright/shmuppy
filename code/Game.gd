extends Node

var joyID:int = 0
var player:KinematicBody2D
var screen_bounds := Rect2(Vector2(0,40), Vector2(960, 500))
const MAX_TRAIL_LENGTH = 5
var topbar = preload("res:///scenes/TopBar.tscn")
var topbar_height = 40.0
var bullet_holder = Node2D.new()
var screen

func _ready() -> void:
	topbar = topbar.instance()
	add_child(topbar)

	screen = load("res:///scenes/ScreenBounds.tscn").instance()
	add_child(screen)
	player = $'ScreenBounds/Player'
	player.z_index = 2
	
	bullet_holder.set_name('BulletHolder')
	bullet_holder.z_index = 1
	add_child(bullet_holder)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
#	screen_bounds.position = Vector2(0, topbar_height)
#	screen_bounds.size = get_viewport().size
	
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
