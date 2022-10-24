extends KinematicBody2D

onready var raycast: RayCast2D = $RayCast2D

var blocks_per_second: int = 4
var moving: bool = false
var direction: Vector2
var screen_size = Vector2(152, 176) # TODO: Automatic screen size detection

func _ready():
	direction = get_direction_random()

func _process(delta):
	if not moving and direction != Vector2.ZERO:
		teleport_out_of_bounds()
		raycast.cast_to = direction * GameManager.TILE_SIZE
		raycast.force_raycast_update()
		if not raycast.is_colliding():
			move(direction)
		else:
			direction = get_direction_random()


# Move, then enable movement again after it's finished
func move(direction_vector: Vector2):
	moving = true
	var tween := create_tween()
	tween.tween_property(self, "position", position + (direction_vector * GameManager.TILE_SIZE), 1.0 / blocks_per_second)
	tween.tween_property(self, "moving", false, 0)


func teleport_out_of_bounds():
	if position.x+GameManager.TILE_SIZE <= 0:
		position.x = screen_size.x
	elif position.x >= screen_size.x:
		position.x = -GameManager.TILE_SIZE


# This also sets raycast rotation_degree
func get_direction_random() -> Vector2:
	var direction: Vector2
	var possible_directions: Array
	
	raycast.cast_to = Vector2.DOWN * GameManager.TILE_SIZE # Reset to default
	
	# Checks all direction around ghost, picks out the onese where there is no collision
	# Converts directions to Vector2, into possible_directions
	for i in range(4):
		var degree := i * 90
		raycast.rotation_degrees = degree
		raycast.force_raycast_update()
		if not raycast.is_colliding():
			possible_directions.append(Vector2.DOWN.rotated(deg2rad(degree)))
	
	# Pick out a random element from the array
	if possible_directions.size() > 0:
		direction = possible_directions[randi() % possible_directions.size()]
	else:
		direction = Vector2.ZERO
#	raycast.cast_to = direction * GameManager.TILE_SIZE
#	raycast.rotation_degrees = rad2deg(direction.angle()) - 90
	raycast.rotation_degrees = 0 # Resets the rotation_degrees
	return direction
