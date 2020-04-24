extends ColorRect

const MAX_HEIGHT = 30

func _process(delta: float) -> void:
	rect_size.y = float(Game.player.cooldown_timer) / float(Game.player.shot_cooldown) * MAX_HEIGHT
