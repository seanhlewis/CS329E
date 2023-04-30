extends CanvasLayer

onready var score = $score
onready var msg = $message
onready var msg_timer = $MsgTimer
onready var startbtn = $startbtn
onready var shopbtn = $shopbtn

signal start_game

func _ready():
	score.bbcode_text = "[center]" + str(globals.highest) + "[/center]"
	$stars/starcount.bbcode_text = "[center]" + str(globals.stars) + "[/center]"
	
func show_message(text):
	msg.bbcode_text = "[center]" + text + "[/center]"
	msg.show()
	msg_timer.start()

func show_game_over():
	show_message("Game Over")
	globals.highest = max(globals.score, globals.highest)
	globals.save(globals.highest, globals.stars, globals.shipn)
	yield(msg_timer, "timeout")
	msg.bbcode_text = "[center]Shoot the Creeps![/center]"
	msg.show()
	#yield(get_tree().create_timer(1), "timeout")
	startbtn.show()
	shopbtn.show()
	
	
func update_score(_new_score):
	globals.score += 1
	score.bbcode_text = "[center]" + str(globals.score) + "[/center]"
	
func _on_start_pressed():
	startbtn.hide()
	shopbtn.hide()
	emit_signal("start_game")
	
func _on_msg_timeout():
	if !globals.game_started:
		score.bbcode_text = "[center]" + str(globals.highest) + "[/center]"
	msg.hide()



func volume_changed(value):
	pass # Replace with function body.

var in_shop = false
func _on_shopbtn_pressed():
	if !in_shop:
		in_shop = true
		$score.hide()
		$message.hide()
		$startbtn.hide()
		$shopbtn.text = "Back"
		$shop.show()
	else:
		in_shop = false
		$shop.hide()
		$score.show()
		$message.show()
		$startbtn.show()
		$shopbtn.text = "Shop"

func _on_buybtn_pressed():
	if !globals.shop_cooldown:
		globals.shop_cooldown = true
		#Check if sufficient funds
		if globals.stars >= 5:
			$shop.display(true)
			globals.stars -= 5
			$stars/starcount.bbcode_text = "[center]" + str(globals.stars) + "[/center]"
			$shop.wait()
			
		else:
			$shop.display(false)
