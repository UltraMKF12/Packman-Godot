extends KinematicBody2D


onready var raycast: RayCast2D = $RayCast2D

var direction: Vector2 = Vector2.ZERO
var blocks_per_second: int = 5
var moving: bool = false
onready var screen_size = Vector2(152, 176) # TODO: Automatic screen size detection

func _process(_delta):
	if Input.is_action_just_pressed("ui_left"):
		direction = Vector2.LEFT
	if Input.is_action_just_pressed("ui_right"):
		direction = Vector2.RIGHT
	if Input.is_action_just_pressed("ui_up"):
		direction = Vector2.UP
	if Input.is_action_just_pressed("ui_down"):
		direction = Vector2.DOWN
	
	#Try to move to direction, if possible
	if(not moving and direction != Vector2.ZERO):
		teleport_out_of_bounds(80) # TEMPORAY SOLUTION, 80 is postion.y of the teleport pipes
		raycast.cast_to = direction * 8
		raycast.force_raycast_update()
		if not raycast.is_colliding():
			move(direction)
		else:
			direction = Vector2.ZERO


func move(direction_vector: Vector2):
	# Move, then enable movement again after it's finished
	moving = true
	var tween := create_tween()
	tween.tween_property(self, "position", position + (direction_vector * 8), 1.0 / blocks_per_second)
	tween.tween_property(self, "moving", false, 0)


# Teleports the player from one side of the map to the other
# Setting position.y FIXES BUG: Pressing up or down lock the player out of bounds
func teleport_out_of_bounds(y):
	if position.x+8 < 0:
		position.x = screen_size.x
		position.y = y
	elif position.x > screen_size.x:
		position.x = -8
		position.y = y


# Eat coins
func _on_Area2D_area_entered(area):
	area.queue_free()
