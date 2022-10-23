extends Node2D

export(PackedScene) onready var coin_scene;
onready var tileset: TileMap = get_parent() # Little hacky but should work


func _ready():
	generate_coins()


func generate_coins() -> void:
	for tile_position in tileset.get_used_cells_by_id(0):
		spawn_coin(tile_position)


func spawn_coin(tile_position: Vector2):
	var coin = coin_scene.instance()
	coin.position = tile_position * 8
	add_child(coin)

