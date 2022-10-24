extends Label


func _process(delta):
	text = "Coins left: " + str(GameManager.coins)
