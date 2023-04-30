extends Control

var tex = null
func _on_FileDialog_file_selected(path):
	if !bought:
		tex = load(path)
		$"S/G/Inv1".texture = tex
	
var _timer = null
func _ready():
	if globals.shipn != 1:
		$current/cur.texture = load("res://ships/ship_" + str(globals.shipn) + ".png")
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(0.1)
	_timer.set_one_shot(false)
	_timer.start()

var bought = false
func wait():
	_timer.set_wait_time(5)
	bought = true

func _on_Timer_timeout():
	rotate()
	if bought:
		_timer.set_wait_time(0.1)
		bought = false
		globals.shop_cooldown = false

var n = 1
func rotate():
	n = round(rand_range(1,210))
	while n in globals.s_list:
		n = round(rand_range(1,210))
	#print(n)
	var image_path = "res://ships/ship_" + str(n) + ".png"
	#print(image_path) 
	_on_FileDialog_file_selected(image_path)

var displaytimer = null
func display(sufficient=false): #sufficient funds false -> no, sufficient funds true -> enjoy
	displaytimer = Timer.new()
	add_child(displaytimer)
	displaytimer.connect("timeout", self, "_on_shop_timeout")
	displaytimer.set_wait_time(2.0)
	displaytimer.set_one_shot(true)
	displaytimer.start()
	if !sufficient:
		$shopmsg.bbcode_text = "[center]" + "insufficient funds" + "[/center]"
	else:
		$shopmsg.bbcode_text = "[center]" + "enjoy your new ship!" + "[/center]"
		#set current ship to image path and remove # from array
		$current/cur.texture = tex
		globals.ship = tex
		globals.s_list.append(n)
		globals.shipn = n
		print(globals.s_list)

func _on_shop_timeout():
	$shopmsg.bbcode_text = ""
	if !bought:
		globals.shop_cooldown = false
