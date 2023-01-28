extends CanvasLayer

onready var score = $score
onready var msg = $message
onready var msg_timer = $MsgTimer
onready var startbtn = $startbtn

signal start_game

func _ready():
	score.bbcode_text = "[center]" + str(globals.highest) + "[/center]"
	
func show_message(text):
	msg.bbcode_text = "[center]" + text + "[/center]"
	msg.show()
	msg_timer.start()

func show_game_over():
	show_message("Game Over")
	globals.highest = max(globals.score, globals.highest)
	globals.save(globals.highest)
	yield(msg_timer, "timeout")
	msg.bbcode_text = "[center]Dodge the Creeps![/center]"
	msg.show()
	#yield(get_tree().create_timer(1), "timeout")
	startbtn.show()
	
func update_score(_new_score):
	globals.score += 1
	score.bbcode_text = "[center]" + str(globals.score) + "[/center]"
	
func _on_start_pressed():
	startbtn.hide()
	emit_signal("start_game")
	
func _on_msg_timeout():
	if !globals.game_started:
		score.bbcode_text = "[center]" + str(globals.highest) + "[/center]"
	msg.hide()



func volume_changed(value):
	pass # Replace with function body.
