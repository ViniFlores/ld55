extends AudioStreamPlayer

func _ready():
	Global.connect("power_changed", func(_a): self.play())
