extends Node

var joyID:int = 0
onready var player = $'../Scene/Player'
var screen_bounds := Rect2(Vector2(0,0), Vector2(960, 540))
const MAX_TRAIL_LENGTH = 10

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	screen_bounds.size = get_viewport().size
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
