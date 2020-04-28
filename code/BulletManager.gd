extends Node2D
var projectile = preload("res:///scenes/Projectile_castmotion.tscn")
var bullet_array = []

func _ready() -> void:
	for i in range (1000):
		var p = projectile.instance()
		
		var xpos = 500.0 + ((i % 64) * 8)
		var ypos = 45.0 + (floor(i / 64) * 8)
		
		p.position = Vector2(xpos, ypos)
		add_child(p)
		bullet_array.append(p)
	Game.bulletcount = 0

func find_disabled_bullet() -> int:
	for i in range (1000):
		if not bullet_array[i].enabled:
			return i
	return -1

func spawn_bullet(data:Dictionary) -> void:
	var index = find_disabled_bullet()
	if index == -1:
		#print("Max capacity reached")
		return
	bullet_array[index].velocity = data.velocity
	bullet_array[index].position = data.position
	bullet_array[index].ownership = data.ownership
	bullet_array[index].radius = data.radius
	bullet_array[index].color = data.color
	bullet_array[index].enable()

func _process(delta: float) -> void:
	# disable bullets offscreen
	pass
