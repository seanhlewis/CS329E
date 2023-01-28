extends Node

var paused = false
var game_started = false
var score = 0
var highest = 0

#Save System
var f = File.new()
var path = "user://f.save"
var d = {"highest": 0}

func _ready():
	if !f.file_exists(path):
		create_save()
	else:
		highest = read_f()
		
func create_save():
	f.open(path, File.WRITE)
	f.store_var(d)
	f.close()
	
func save(hiscore):
	d["highest"] = hiscore
	f.open(path, File.WRITE)
	f.store_var(d)
	f.close()
	
func read_f():
	f.open(path, File.READ)
	d = f.get_var()
	f.close()
	return d["highest"]
