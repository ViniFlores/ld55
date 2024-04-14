extends Node2D

var message_scene = preload("res://Scenes/message.tscn")

func _ready():
	var msg1 = show_message("Farmer", "Such a wonderful world, killing anything magically drops loot !!!")
	msg1.connect('tree_exited', func():
		var msg2 = show_message("Farmer", "Since it is acceptable to [shake rate=20.0 level=5 connected=1]SLAY[/shake] demons, i'm going to hire some cultists to summon them for me! :)")
		msg2.connect('tree_exited', func():
			var msg3 = show_message('Controls', "WASD - Movement\nLeft Mouse Click - Attack\nR - Hire cultists for 100gold\nT - Increase weapon power for 50gold\nY - Heal for 200gold")
			msg3.connect('tree_exited', func():
				show_message("Farmer", "I have exactly 100 gold, let's begin by hiring 1 cultist!\n")
				)
			)
		)

func show_message(title, message):
	var instance = message_scene.instantiate()
	instance.title = title
	instance.message = message
	get_tree().root.get_child(-1).add_child(instance)
	return instance
