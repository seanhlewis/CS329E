extends Area2D

export (int) var SPEED: int = 500
onready var ui = $"../UI"

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta
	
func destroy():
	queue_free()


func _on_Nift_area_entered(area):
	destroy()
	
func _on_Nift_body_entered(body):
	destroy()
	body.dead()
	#body.queue_free()
	ui.update_score(globals.score)
	globals.stars += 1
	ui.get_node("stars/starcount").bbcode_text = "[center]" + str(globals.stars) + "[/center]"

func _on_VisibilityNotifier2D_screen_exited():
	# In future would set this to delete after 5 seconds if not coming into screen again
	destroy()
