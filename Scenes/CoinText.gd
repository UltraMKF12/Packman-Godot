extends Label


func _process(delta):
	text = "Coins left: " + str(GameManager.coins)
	$FpsCounter.text = str(Engine.get_frames_per_second())
