extends Node


onready var score_timer = $ScoreTimer
onready var enemy_timer = $EnemyTimer
onready var start_timer = $StartTimer
onready var p = $Player
onready var sp = $startpos
onready var e_spawn = $enemypath/enemyspawn
onready var ui = $UI
onready var bgm = $musicbgm
onready var death_bgm = $deathbgm

export (PackedScene) var enemy_prefab

func _ready():
	randomize()

func new_game():
	if globals.shipn != 1:
		p.get_node("spr1").texture = load("res://ships/ship_" + str(globals.shipn) + ".png")
	p.reset()
	globals.lockkeys = false
	globals.game_started = true
	globals.score = -1
	p.start(sp.position)
	start_timer.start()
	ui.update_score(globals.score)
	ui.show_message("Get Ready")
	bgm.play()
	ui.get_node("health").visible = true

func gameover():
	globals.shop_cooldown = false
	globals.lockkeys = true
	globals.game_started = false
	score_timer.stop()
	enemy_timer.stop()
	ui.show_game_over()
	get_tree().call_group("enemy", "queue_free")
	bgm.stop()
	death_bgm.play()

func _on_start_timeout():
	score_timer.start()
	enemy_timer.start()
	
func _on_enemy_timeout():
	var pieces_of_eight = round(rand_range(0,2))
	#print(pieces_of_eight)
	#match pieces_of_eight:
	#	0: $enemypath.global_position = p.pos.get_global_position() + Vector2(100, 100)
	#	1: $enemypath.global_position = p.pos.get_global_position() + Vector2(0, 100)
	#	2: $enemypath.global_position = p.pos.get_global_position() + Vector2(100, 0)
	#print("Enemy path global position is now", e_spawn.global_position)
	e_spawn.global_position += Vector2(1000,1000)
	#print("Custom enemy global position is now", e_spawn.global_position)
	
	#Need to figure out how to make this around viewport, not starting viewport
	
	var e = enemy_prefab.instance()
	e_spawn.offset = randi()
	var direction = e_spawn.rotation + PI / 2
	e.position = e_spawn.position
	direction += rand_range(-PI / 4, PI / 4)
	e.rotation = direction
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	e.linear_velocity = velocity.rotated(direction)
	add_child(e)

func _on_score_timeout():
	#ui.update_score(globals.score)
	pass

func pause_toggle():
	if globals.paused:
		ui.show_message("Paused")
		get_tree().paused = true
	else:
		ui.msg.hide()
		get_tree().paused = false

