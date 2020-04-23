extends Sprite

func _process(delta: float) -> void:
	region_rect.size.x = lerp(region_rect.size.x, Game.player.energy, 0.2)
