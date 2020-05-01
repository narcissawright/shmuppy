extends Label

func _process(t:float) -> void:
	text = 'shots fired: ' + str(Game.player.shots_fired)
