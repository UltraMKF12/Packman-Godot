extends KinematicBody2D


onready var raycast: RayCast2D = $RayCast2D
onready var sprite: AnimatedSprite = $AnimatedSprite

var direction: Vector2 = Vector2.ZERO
var blocks_per_second: int = 5
var moving: bool = false
var screen_size = Vector2(152, 176) # TODO: Automatic screen size detection


func _process(_delta):
	if Input.is_action_just_pressed("ui_left"):
		direction = Vector2.LEFT
	if Input.is_action_just_pressed("ui_right"):
		direction = Vector2.RIGHT
	if Input.is_action_just_pressed("ui_up"):
		direction = Vector2.UP
	if Input.is_action_just_pressed("ui_down"):
		direction = Vector2.DOWN
	
	play_audio()
	
	#Try to move to direction, if possible
	if(not moving and direction != Vector2.ZERO):
		teleport_out_of_bounds()
		rotate_sprite(direction)
		raycast.cast_to = direction * GameManager.TILE_SIZE
		raycast.force_raycast_update()
		if not raycast.is_colliding():
			move(direction)
		else:
			direction = Vector2.ZERO


# Move, then enable movement again after it's finished
func move(direction_vector: Vector2):
	moving = true
	var tween := create_tween()
	tween.tween_property(self, "position", position + (direction_vector * GameManager.TILE_SIZE), 1.0 / blocks_per_second)
	tween.tween_property(self, "moving", false, 0)


# Teleports the player from one side of the map to the other
# Setting position.y FIXES BUG: Pressing up or down locks the player out of bounds
func teleport_out_of_bounds():
	if position.x+GameManager.TILE_SIZE <= 0:
		position.x = screen_size.x
	elif position.x >= screen_size.x:
		position.x = -GameManager.TILE_SIZE


func rotate_sprite(direction: Vector2):
	if direction == Vector2.RIGHT:
		sprite.flip_h = false
		sprite.rotation_degrees = 0
	
	if direction == Vector2.LEFT:
		sprite.flip_h = true
		sprite.rotation_degrees = 0
	
	if direction == Vector2.UP:
		if sprite.flip_h: sprite.rotation_degrees = 90
		else: sprite.rotation_degrees = -90
	
	if direction == Vector2.DOWN:
		if sprite.flip_h: sprite.rotation_degrees = -90
		else: sprite.rotation_degrees = 90


# Plays sound while eating coin food stuff
func play_audio():
	if $PlayTimer.time_left > 0 and not $AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()
	elif $PlayTimer.time_left == 0:
		$AudioStreamPlayer.stop()


# Eat coins
func _on_Area2D_area_entered(area):
	$PlayTimer.start($AudioStreamPlayer.stream.get_length())
	area.queue_free()
