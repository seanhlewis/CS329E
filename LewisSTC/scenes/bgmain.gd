extends ParallaxLayer

export(float) var BG_SPEED = -15.0

func _process(delta) -> void:
	if globals.game_started:
		self.motion_offset.y += BG_SPEED * delta * (1 + globals.score / 10.0)
	else:
		self.motion_offset.y += BG_SPEED * delta
