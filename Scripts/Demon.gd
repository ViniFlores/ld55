extends Character

var target_pos
var ritual

var balloon_scene = preload("res://Scenes/balloon.tscn")

var messages = [
	"This place is so much better than hell",
	"Thanks so much for summoning me!",
	"Wow, the sky is so blue! I never knew colors could be this vibrant.",
	"Ah, the smell of fresh air. It's invigorating.",
	"I never knew clouds could be so fluffy. They almost look... comforting.",
	"A gentle breeze... it's like a caress.",
	"Even the simplest things hold such beauty.",
	"Freedom... it's more precious than anything I've ever known.",
	"I can feel the earth beneath my feet... it's grounding."
]

func _ready():
	global_position = get_random_target_pos()
	send_message()
	super()

func send_message():
	if randf() > 0.6:
		var balloon = balloon_scene.instantiate()
		balloon.message = messages[randi_range(0, 8)]
		balloon.global_position = global_position
		get_tree().root.get_child(-1).add_child(balloon)
	var timer = get_tree().create_timer(4)
	timer.connect("timeout", send_message)

func _physics_process(delta):
	if stun <= 0:
		if not target_pos:
			get_random_target_pos()
			velocity = Vector2(0, 0)
		else:
			var dist = target_pos - global_position
			if dist.length() < 10:
				get_random_target_pos()
			velocity = (target_pos - global_position).normalized() * SPEED
	
	super(delta)

func get_random_target_pos():
	var shape = ritual.get_node("Area").get_node("CollisionShape2D") as CollisionShape2D
	var spawnArea = shape.shape.extents
	var origin = shape.global_position - spawnArea*2
	
	target_pos = Vector2(randf_range(origin.x, origin.x + spawnArea.x * 4), randf_range(origin.y, origin.y + spawnArea.y * 4))
	return target_pos
	
func die():
	var instance = coin_scene.instantiate()
	instance.global_position = global_position
	get_tree().root.get_child(-1).add_child(instance)
	super()
