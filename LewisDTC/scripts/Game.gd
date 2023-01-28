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
	globals.game_started = true
	globals.score = -1
	p.start(sp.position)
	start_timer.start()
	ui.update_score(globals.score)
	ui.show_message("Get Ready")
	bgm.play()

func gameover():
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
	ui.update_score(globals.score)

func pause_toggle():
	if globals.paused:
		ui.show_message("Paused")
		get_tree().paused = true
	else:
		ui.msg.hide()
		get_tree().paused = false

