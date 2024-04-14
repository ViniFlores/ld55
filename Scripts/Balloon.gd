extends Node2D

@export var message: String
@onready var label = $Label

func _ready():
	if message:
		label.text = message
