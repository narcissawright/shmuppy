extends Node2D
var projectile = preload("res:///scenes/Projectile_castmotion.tscn")
var bullet_array = []
var disabled_list = []
var count = 0
const MAX_COUNT = 1000

func _ready() -> void:
	z_index = 1
	for i in range (MAX_COUNT):
		var p = projectile.instance()
		
		var xpos = (i % 64) * 8
		var ypos = floor(i / 64) * 8
		
		p.position = Vector2(xpos, ypos)
		p.bullet_index = i
		add_child(p)
		bullet_array.append(p)
		disabled_list.append(i)

func add_to_disabled(index:int) -> void:
	disabled_list.append(index)
	count -= 1

func spawn_bullet(data:Dictionary) -> void:
	var index = disabled_list.pop_front()
	if index == -1:
		#print("Max capacity reached")
		return
	bullet_array[index].velocity = data.velocity
	bullet_array[index].position = data.position
	bullet_array[index].ownership = data.ownership
	bullet_array[index].radius = data.radius
	bullet_array[index].color = data.color
	bullet_array[index].enable()
	count += 1
