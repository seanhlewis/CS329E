extends ParallaxLayer

export(float) var STAR_SPEED = -10.0 

func _process(delta) -> void:
	if globals.game_started:
		self.motion_offset.y += STAR_SPEED * delta * (1 + globals.score / 10.0)
	else:
		self.motion_offset.y += STAR_SPEED * delta
