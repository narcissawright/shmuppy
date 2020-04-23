extends Node2D

func _process(delta: float) -> void:
	position += Game.player.screen_velocity
