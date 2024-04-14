extends Character

var slash_scene = preload("res://Scenes/slash.tscn")
var slash_cooldown

var slash_sounds = [
	preload("res://Assets/sfx/slash1.mp3"),
	preload("res://Assets/sfx/slash2.mp3"),
	preload("res://Assets/sfx/slash3.mp3")
]
@onready var audio_player = $AudioPlayer as AudioStreamPlayer2D

func _ready():
	Global.player = self
	super()

func _physics_process(delta):
	if stun <= 0:
		if Input.is_action_pressed("slash"):
			slash()
		var direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
		velocity = direction.normalized() * SPEED
	
	super(delta)

func _unhandled_input(event):
	if state == 'dead':
		return
	if event.is_action_pressed("slash"):
		slash()
	if event.is_action_pressed("heal"):
		heal()

func slash():
	if slash_cooldown and slash_cooldown.time_left > 0:
		return
	var instance = slash_scene.instantiate()
	instance.rotation = get_angle_to(get_global_mouse_position())
	add_child(instance)
	slash_cooldown = get_tree().create_timer(0.5)
	audio_player.stream = slash_sounds[randi_range(0, 2)]
	audio_player.play()
	
@onready var heal_sound = preload("res://Assets/sfx/heal.mp3")
func heal():
	if Global.gold >= 200:
		Global.gold -= 200
		hp = MAX_HP
		audio_player.stream = heal_sound
		audio_player.play()

var message_scene = preload("res://Scenes/message.tscn")

var gameover_sound = preload("res://Assets/sfx/gameover.mp3")
func prompt_restart():
	var instance = message_scene.instantiate()
	audio_player.stream = gameover_sound
	audio_player.play()
	instance.title = 'Game Over'
	instance.message = "Score: %s\nPress next to restart" % Global.score
	get_tree().root.get_child(-1).add_child(instance)
	instance.connect('tree_exited', func():
		get_tree().reload_current_scene()
		Global.reset()
		)
