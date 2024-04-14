extends Character

var balloon_scene = preload("res://Scenes/balloon.tscn")
var target
var slash_scene = preload("res://Scenes/enemy_slash.tscn")
var slash_cooldown

var messages = [
	"Stop killing our friends!!!",
	"Why are we summoning our kind to kill?",
	"What have we done to you !?"
]
var slash_sounds = [
	preload("res://Assets/sfx/slash1.mp3"),
	preload("res://Assets/sfx/slash2.mp3"),
	preload("res://Assets/sfx/slash3.mp3")
]

@onready var audio_player = $AudioPlayer

func _ready():
	send_message()
	super()

func send_message():
	if randf() > 0.6:
		var balloon = balloon_scene.instantiate()
		balloon.message = messages[randi_range(0, 2)]
		balloon.global_position = global_position
		get_tree().root.get_child(-1).add_child(balloon)
	var timer = get_tree().create_timer(4)
	timer.connect("timeout", send_message)

func _physics_process(delta):
	if stun <= 0:
		for body in $DetectAlly.get_overlapping_bodies():
			slash(body.global_position)
			break
		if target and is_instance_valid(target):
			var dir = target.global_position - global_position
			var dist = dir.length()
			if dist > 100 or dist < 50:
				var target_pos = target.global_position - dir.normalized() * 2
				velocity = (target_pos - global_position).normalized() * SPEED
			else:
				velocity = Vector2.ZERO
		else:
			get_target()
			velocity = Vector2.ZERO
	super(delta)

func get_target():
	var targets = get_tree().get_nodes_in_group('allies')
	var nearest
	for t in targets:
		if t.state == 'dead':
			continue
		if not nearest:
			nearest = t
		else:
			if (t.global_position - global_position).length() < (nearest.global_position - global_position).length():
				print(nearest)
				nearest = t
	target = nearest
	if target:
		target.connect("dead", func(): target = null)

func slash(target_pos):
	if slash_cooldown and slash_cooldown.time_left > 0:
		return
	var instance = slash_scene.instantiate()
	instance.rotation = get_angle_to(target_pos)
	add_child(instance)
	slash_cooldown = get_tree().create_timer(1)
	audio_player.stream = slash_sounds[randi_range(0, 2)]
	audio_player.play()

func hit(vhit, dir):
	target = Global.player
	super(vhit, dir)

func die():
	var instance = coin_scene.instantiate()
	instance.global_position = global_position
	get_tree().root.get_child(-1).add_child(instance)
	super()
