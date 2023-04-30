extends RigidBody2D

onready var anim = $AnimatedSprite

onready var player_pos = $"../Player/pos"
export(PackedScene) var NIFT: PackedScene = preload("res://projectiles/ENift.tscn")
onready var atkTimer = $atkTimer
var attack = false
var dead = false

func _ready():
	anim.playing = true
	var mob_types = anim.frames.get_animation_names()
	#anim.animation = mob_types[randi() % mob_types.size()]


func _on_enemy_screen_exited():
	#queue_free()
	pass

func attack_player():
	var nift_direction = self.global_position.direction_to(player_pos.get_global_position())
	throw_nift(nift_direction)

func throw_nift(nift_direction: Vector2):
	if NIFT:
		var nift = NIFT.instance()
		get_tree().current_scene.add_child(nift)
		nift.global_position = self.global_position
		
		var nift_rotation = nift_direction.angle()
		nift.rotation = nift_rotation
		#if distance to play is within 100 pixels
		if ((sqrt(pow(player_pos.get_global_position().x,2) + (pow(player_pos.get_global_position().y,2)))) - (sqrt(pow(self.get_global_position().x,2)+(pow(self.get_global_position().y,2))))) < 50:
			$"../laserbgm".play()
		atkTimer.start()

func _on_atkTimer_timeout():
	$AnimatedSprite.play("attack")
	attack = true
	attack_player()

func disable_col():
	$col.disabled = true

func dead():
	if !dead:
		$"../deathbgm".play()
		self.contact_monitor = false
		call_deferred("disable_col")
		dead = true
		atkTimer.stop()
		$explode.emitting = true
		$AnimatedSprite.visible = false

func _on_AnimatedSprite_animation_finished():
	if attack:
		$AnimatedSprite.play("idle")
