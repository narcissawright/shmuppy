extends Area2D

func _on_EnergyPacket_body_entered(body: Node) -> void:
	Game.player.energy += 100.0
	queue_free()
