extends Node2D

var cooldown = 0
var enemy_scene = preload("res://Scenes/enemy.tscn")

func _physics_process(delta):
	if Global.phase != 'survive':
		return
	cooldown = max(0, cooldown - delta)
	if cooldown > 0:
		return
	
	var shapes = [$Area2D/CollisionShape2D, $Area2D/CollisionShape2D2, $Area2D/CollisionShape2D3, $Area2D/CollisionShape2D4]
	var shape = shapes[randi_range(0, 3)]
	
	var spawnArea = shape.shape.extents
	var origin = shape.global_position - spawnArea
	
	var pos = Vector2(randf_range(origin.x, origin.x + spawnArea.x * 2), randf_range(origin.y, origin.y + spawnArea.y * 2))
	
	var instance = enemy_scene.instantiate()
	instance.global_position = pos
	get_tree().root.get_child(-1).add_child(instance)
	
	cooldown = 12 * Global.enemy_timer_multiplier
