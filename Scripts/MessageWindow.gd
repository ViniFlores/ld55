extends CanvasLayer

@export var title_label: Label
@export var message_label: RichTextLabel

@export var title: String = 'Title'
@export var message: String = 'Message'

func _ready():
	get_tree().paused = true
	title_label.text = title
	message_label.text = message

func _on_button_pressed():
	get_tree().paused = false
	queue_free()
