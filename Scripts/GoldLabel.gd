extends Label

func _ready():
	Global.connect("gold_changed", func(val): text = str(val))
