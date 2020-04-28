extends Label

func _process(t:float) -> void:
	#text = str(Game.bullet_holder.get_child_count()) + ' active'
	text = str(BulletManager.count) + ' active'
