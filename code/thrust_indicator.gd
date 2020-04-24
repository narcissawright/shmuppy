extends Sprite
func _process(delta: float) -> void:
	visible = Input.is_action_pressed("thrust")
