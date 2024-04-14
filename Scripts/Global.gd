extends Node

signal gold_changed(amount)
signal power_changed(amount)
var score = 100
var gold = 100 :
	set(val):
		gold = val
		emit_signal("gold_changed", val)
var power = 50 :
	set(val):
		power = val
		emit_signal("power_changed", val)
var enemy_power = 10
var player

var enemy_timer_multiplier = 1
var phase = 'gather'

func _unhandled_input(event):
	if event.is_action_pressed("upgrade"):
		upgrade()
	if event.is_action_pressed("mute"):
		mute()

func _physics_process(delta):
	if phase == 'survive':
		enemy_timer_multiplier -= enemy_timer_multiplier * delta * 0.006
		print(enemy_timer_multiplier)

func earn_gold(amount):
	gold += amount
	score += amount
	if score >= 200:
		phase = 'survive'

func upgrade():
	if score > 100 and gold >= 50:
		gold -= 50
		power += 10

func reset():
	score = 100
	gold = 100
	power = 50
	phase = 'gather'

var mute_b = false
func mute():
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_idx, not mute_b)
	mute_b = not mute_b
	
