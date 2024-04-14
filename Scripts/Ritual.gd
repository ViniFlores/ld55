extends Node2D

var summoner_scene = preload("res://Scenes/summoner.tscn")

var summoners = []

func _unhandled_input(event):
	if event.is_action_pressed("add_summoner"):
		add_summoner()

func add_summoner():
	if Global.gold < 100:
		return
	var summoner_spots = get_tree().get_nodes_in_group("summoner_spots")
	var selected_spot
	for spot in summoner_spots:
		if spot.status == 'empty':
			spot.status = 'busy'
			selected_spot = spot
			break
	if not selected_spot:
		return
	
	var instance = summoner_scene.instantiate()
	instance.spot = selected_spot
	instance.global_position = selected_spot.global_position
	instance.DIRECTION = selected_spot.DIRECTION
	instance.ritual = self
	get_tree().root.get_child(-1).add_child(instance)
	Global.gold -= 100
	
