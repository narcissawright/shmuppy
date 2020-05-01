extends Particles2D
var total_time = 0.0

func _ready() -> void:
	set_process(false)

func activate(v) -> void:
	process_material = process_material.duplicate()
	process_material.color = get_parent().color
	process_material.direction = Vector3(v.x, v.y, 0).normalized()
	process_material.initial_velocity = v.length() * 45
	emitting = true
	set_process(true)
	
func _process(t:float) -> void:
	total_time += t
	if total_time > 1.0:
		total_time = 0.0
		get_parent().disable()
		set_process(false)
