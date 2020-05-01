extends Label

func _process(t:float) -> void:
	text = 'destroyed: ' + str(Game.player.destroyed)
