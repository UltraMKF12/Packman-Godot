extends Node

const TILE_SIZE = 8
var coins = 0

func _ready():
	randomize()

func _process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("restart"):
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
