extends KinematicBody2D

signal hit_player
signal paused

onready var s = $"."
onready var anim = $spr
onready var hitboxcol = $hitbox/CollisionShape2D
export var speed = 400
var screen_size
var screen_padding = 25

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	if not globals.paused:
		var velocity = Vector2.ZERO
		if Input.is_action_pressed("mvu"):
			velocity.y -= speed * delta
		if Input.is_action_pressed("mvr"):
			velocity.x += speed * delta
		if Input.is_action_pressed("mvd"):
			velocity.y += speed * delta
		if Input.is_action_pressed("mvl"):
			velocity.x -= speed * delta
		if Input.is_action_just_pressed("ui_cancel") and globals.game_started:
			globals.paused = true
			emit_signal("paused")
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			anim.play()
		else:
			#IDLE position
			anim.animation = "walk"
			#anim.stop()
		if velocity.x != 0:
			anim.animation = "walk"
			anim.flip_v = false
			anim.flip_h = velocity.x < 0
		elif velocity.y != 0:
			anim.animation = "up"
			anim.flip_v = velocity.y > 0
		position += velocity * delta
		position.x = clamp(position.x, screen_padding, screen_size.x - screen_padding)
		position.y = clamp(position.y, screen_padding, screen_size.y - screen_padding)
	else:
		if Input.is_action_just_pressed("ui_cancel"):
			globals.paused = false
			emit_signal("paused")

func _on_hitbox_collide(body):
	if body.is_in_group("enemy"):
		hide()
		emit_signal("hit_player")
		hitboxcol.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	hitboxcol.disabled = false
