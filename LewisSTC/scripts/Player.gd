extends KinematicBody2D

signal hit_player
signal paused

onready var s = $"."
#onready var anim = $spr1
onready var hitboxcol = $hitbox/CollisionShape2D
export var speed = 400
var screen_size
var screen_padding = 25

var input_vector = Vector2.ZERO
export(PackedScene) var NIFT: PackedScene = preload("res://projectiles/Nift.tscn")
onready var atkTimer = $atkTimer

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	$cam.rotation = 0
	if not globals.paused and not globals.lockkeys:
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
			#anim.play()
		else:
			#IDLE position
			pass
			#anim.animation = "walk"
			#anim.stop()
		if velocity.x != 0:
			#anim.animation = "walk"
			pass
			#anim.flip_v = false
			#anim.flip_h = velocity.x < 0
		elif velocity.y != 0:
			pass
			#anim.animation = "up"
			#anim.flip_v = velocity.y > 0
		input_vector.x = Input.get_action_strength("mvr") - Input.get_action_strength("mvl")
		input_vector.y = Input.get_action_strength("mvd") - Input.get_action_strength("mvu")
		input_vector = input_vector.normalized()
		
		if input_vector != Vector2.ZERO:
			rotation = lerp(rotation + PI/2, input_vector.angle(), .1)
		position += velocity * delta
		
		if Input.is_action_just_pressed("action_attack") and atkTimer.is_stopped():
			#get_global_mouse_position() for shooting towards mouse
			#print("rotation is: ",  rotation)
			var nift_direction = self.global_position.direction_to($cannon.global_position)
			
			throw_nift(nift_direction)
		#position = position.linear_interpolate(position, delta * speed)
		#position.x = clamp(position.x, screen_padding, screen_size.x - screen_padding)
		#position.y = clamp(position.y, screen_padding, screen_size.y - screen_padding)
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
	
func hurt():
	#print("OW")
	$"../UI/health".value -= 5
	if $"../UI/health".value <= 0 and !globals.dead:
		$explode.emitting = true
		$spr1.visible = false
		$Particles2D.visible = false
		globals.dead = true
		$"../UI/health".visible = false
		$"../../Game".gameover()
	
func reset():
	$spr1.visible = true
	$Particles2D.visible = true
	globals.dead = false
	$"../UI/health".value = 100
	
func throw_nift(nift_direction: Vector2):
	if NIFT:
		var nift = NIFT.instance()
		get_tree().current_scene.add_child(nift)
		nift.global_position = $cannon.global_position#self.global_position
		nift.z_index = -1
		var nift_rotation = nift_direction.angle()
		nift.rotation = nift_rotation
		$"../laserbgm".play()
		atkTimer.start()
