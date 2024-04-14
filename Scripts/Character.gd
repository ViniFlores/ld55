extends CharacterBody2D

class_name Character

signal dead

var coin_scene = preload("res://Scenes/coin.tscn")

@export var stun_immune: bool = false
@export var HP_HUD_BAR: ProgressBar
@onready var hp_bar = $ProgressBar
@export var MAX_HP = 100:
	set(val):
		MAX_HP = val
		if hp_bar:
			hp_bar.max_value = val
		if HP_HUD_BAR:
			HP_HUD_BAR.max_value = val
@export var SPEED = 150.0
@onready var anim_player = $AnimationPlayer

var DIRECTION = "LEFT"
var stun = 0
var state = "alive"

@onready var hp = MAX_HP :
	set(val):
		hp = val
		if hp_bar:
			hp_bar.value = val
		if HP_HUD_BAR:
			HP_HUD_BAR.value = val

func _ready():
	hp_bar.max_value = MAX_HP
	if HP_HUD_BAR:
		HP_HUD_BAR.max_value = MAX_HP
		HP_HUD_BAR.value = hp
	hp_bar.value = hp
	
	if DIRECTION == 'RIGHT':
		$Orientation.scale = Vector2(-1, 1)

func _physics_process(delta):
	if state == 'dead':
		return
	stun = max(0, stun - delta)
	var animation = "walk" if velocity.length() > 0 else "idle"
	anim_player.speed_scale = 3 if animation == "walk" else 1
	anim_player.play(animation)
	if stun <= 0:
		if velocity.x > 0 and DIRECTION == 'LEFT':
			var tween = create_tween()
			tween.tween_property($Orientation, "scale", Vector2(-1, 1), 0.1)
			DIRECTION = 'RIGHT'
		elif velocity.x < 0 and DIRECTION == 'RIGHT':
			var tween = create_tween()
			tween.tween_property($Orientation, "scale", Vector2(1, 1), 0.1)
			DIRECTION = 'LEFT'
	move_and_collide(velocity * 0.02)

func hit(val, dir):
	if state == 'dead':
		return
	hp -= val
	if hp <= 0:
		die()
	velocity = dir.normalized() * 500
	stun = 0.1

func die():
	emit_signal('dead')
	state = 'dead'
	anim_player.play("die")
