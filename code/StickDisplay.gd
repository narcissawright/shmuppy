extends Sprite

# necessary for trail
var radius = 3.0
var color = Color(0.25,0,1)
var which:String
onready var no_move = $'NoMove'

func _ready() -> void:
	if name == 'RightStick':
		which = 'right'
	else:
		which = 'left'

func _process(delta: float) -> void:
	var pos = Game.get_stick_input(which)
	
	if pos == Vector2.ZERO:
		no_move.show()
	else:
		no_move.hide()
	
	if pos.is_normalized():
		get_parent().frame = 1
	else:
		get_parent().frame = 0
	position = pos * 12.0
