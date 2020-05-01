extends KinematicBody2D
var health:float = 200.0
var velocity := Vector2(-20, 0)

func _physics_process(t:float) -> void:
	velocity = move_and_slide(velocity)

func hit(dmg) -> void:
	health -= dmg
	if health <= 0.0:
		queue_free()
