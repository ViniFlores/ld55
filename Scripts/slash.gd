extends Node2D

@onready var hitbox = $Hitbox as Area2D

func deal_damage():
	for body in hitbox.get_overlapping_bodies():
		body.hit(Global.power, body.global_position - global_position)
	
