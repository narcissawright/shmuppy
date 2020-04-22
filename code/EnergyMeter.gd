extends Sprite
onready var amount_node = $'Amount'

func _process(delta: float) -> void:
	amount_node.region_rect.size.x = Game.player.energy
