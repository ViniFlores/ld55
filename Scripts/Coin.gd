extends Area2D


func _on_body_entered(_body):
	Global.earn_gold(10)
	queue_free()
