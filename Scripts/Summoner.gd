extends Character

var demon_scene = preload("res://Scenes/demon.tscn")

var spot
var ritual
var summon

func _physics_process(_delta):
	if not summon:
		$Line2D.visible = false
		summon = demon_scene.instantiate()
		summon.connect("dead", func(): summon = null)
		summon.global_position = ritual.get_node('SpawnPosition').global_position
		summon.ritual = ritual
		get_tree().root.get_child(-1).add_child(summon)
	else:
		$Line2D.visible = true
		$Line2D.points = [Vector2(0,0), summon.global_position - global_position]

func die():
	spot.status = 'empty'
	if summon:
		summon.queue_free()
	queue_free()
