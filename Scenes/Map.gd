extends TileMap

onready var coin_scene = preload("res://Scenes/CoinFood.tscn")

func spawn_coin(tile_position: Vector2):
	var coin = coin_scene.instance()
	coin.position = tile_position * 8
	add_child(coin)

func generate_coins() -> void:
	for tile_position in get_used_cells_by_id(0):
		spawn_coin(tile_position)

func _ready():
	generate_coins()
