extends Node2D

export(PackedScene) onready var coin_scene;
onready var tileset: TileMap = get_parent() # Little hacky but should work


func _ready():
	GameManager.coins = 0
	generate_coins()


func generate_coins() -> void:
	for tile_position in tileset.get_used_cells_by_id(0):
		spawn_coin(tile_position)
		GameManager.coins += 1


func spawn_coin(tile_position: Vector2):
	var coin = coin_scene.instance()
	coin.position = tile_position * GameManager.TILE_SIZE
	add_child(coin)

