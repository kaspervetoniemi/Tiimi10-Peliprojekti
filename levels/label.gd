extends Label

func _process(delta):
	# This constantly updates the text on screen to match the global score
	text = "Score: " + str(Global.score)
