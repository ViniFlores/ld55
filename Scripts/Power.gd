extends Label

func _ready():
	Global.connect("power_changed", func(val): text = str(val))
