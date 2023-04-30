extends Node

var paused = false
var game_started = false
var score = 0
var stars = 0
var highest = 0
var dead = false
var lockkeys = true
var ship = null
var shipn = 1
var shop_cooldown = false
var s_list = []

#Save System
var f = File.new()
var path = "user://f.save"
var d = {"highest": 0, "stars": 0, "ship": null}

var reset_data = false

func _ready():
	if reset_data: #Overriding previous save data for debug
		create_save()
	if !f.file_exists(path):
		create_save()
	else:
		highest = read_f()
		stars = read_s()
		shipn = read_q()
		print("Read in data")
		
func create_save():
	f.open(path, File.WRITE)
	f.store_var(d)
	f.close()
	
func save(hiscore, stars, shipn):
	d["highest"] = hiscore
	d["stars"] = stars
	d["ship"] = shipn
	f.open(path, File.WRITE)
	f.store_var(d)
	f.close()
	
func read_f():
	f.open(path, File.READ)
	d = f.get_var()
	f.close()
	return d["highest"]
func read_s():
	f.open(path, File.READ)
	d = f.get_var()
	f.close()
	return d["stars"]
func read_q():
	f.open(path, File.READ)
	d = f.get_var()
	f.close()
	return d["ship"]
