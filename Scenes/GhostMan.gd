extends KinematicBody2D

onready var raycast: RayCast2D = $RayCast2D

func _ready():
	start_moving()

func start_moving():
	var direction: Vector2 = choose_direction_random()
	print(direction)

func choose_direction_random() -> Vector2:
	var direction: Vector2
	var possible_directions: Array
	
	# Checks all direction around ghost, picks out the onese where there is no collision
	# Converts directions to Vector2, into possible_directions
	for i in range(4):
		var degree := i * 90
		raycast.rotation_degrees = degree
		raycast.force_raycast_update()
		if not raycast.is_colliding():
			possible_directions.append(Vector2.DOWN.rotated(deg2rad(degree)))
	
	# Pick out a random element from the array
	direction = possible_directions[randi() % possible_directions.size()]
	raycast.rotation_degrees = rad2deg(direction.angle()) - 90
	return direction
