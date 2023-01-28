extends RigidBody2D

onready var anim = $AnimatedSprite




func _ready():
	anim.playing = true
	var mob_types = anim.frames.get_animation_names()
	anim.animation = mob_types[randi() % mob_types.size()]


func _on_enemy_screen_exited():
	queue_free()
