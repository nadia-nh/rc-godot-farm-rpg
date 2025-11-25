class_name GrassLand
extends Node2D
## GrassLand
##
## Manages the tile map and updates tiles based on their state. Handles tilling,
## watering, harvesting, and planting, and updates tiles when the day changes.

# Indices for the tile maps
const GRASS_INDEX = 0
const TILLED_GRASS_INDEX = 1
const TILLED_WATERED_INDEX = 2

var _crop_scene: PackedScene = preload("res://Scenes/crop_node.tscn")
var _tile_data_at_pos: Dictionary[Vector2i, GrassTileData]
var _watered_tiles : Dictionary[Vector2i, GrassTileData]
var _coords : Vector2i

@onready var _tile_map: TileMapLayer = $GrassTileMap
@onready var _farm_manager: FarmManager = $".."

func _ready():
	for cell in _tile_map.get_used_cells():
		_tile_data_at_pos[cell] = GrassTileData.new()

# Till this tile if it doesn't have a crop and is not already tilled
func till_tile(player_pos: Vector2):
	var tile_data := _get_tile_data_at_pos(player_pos)

	if tile_data.has_crop():
		return

	if tile_data.is_tilled:
		return

	tile_data.is_tilled = true
	_update_tile_map(_coords, TILLED_GRASS_INDEX)

# Water this tile only if it's already tilled and not watered
func water_tile(player_pos: Vector2):
	var tile_data := _get_tile_data_at_pos(player_pos)

	if not tile_data.is_tilled:
		return

	if tile_data.is_watered:
		return

	tile_data.is_watered = true
	if tile_data.has_crop():
		tile_data.crop_node.water()

	_watered_tiles[_coords] = tile_data
	_update_tile_map(_coords, TILLED_WATERED_INDEX)

# Harvest the crop on this tile if one is present
func harvest_tile(player_pos: Vector2):
	var tile_data := _get_tile_data_at_pos(player_pos)

	if not tile_data.has_crop():
		return

	if not tile_data.crop_node.can_be_harvested():
		return

	_farm_manager.sell_crop(tile_data.crop_node.get_crop_resource())

	tile_data.crop_node.clear()
	tile_data.crop_node = null
	_watered_tiles.erase(_coords)

# Plant a crop on this tile if the soil has been tilled
func plant_tile(crop_resource : CropResource, player_pos: Vector2):
	var tile_data := _get_tile_data_at_pos(player_pos)

	if not tile_data.is_tilled:
		return

	_farm_manager.use_seed(crop_resource)

	var crop: CropNode = _crop_scene.instantiate()
	add_child(crop)
	# Convert tile coordinates back to world position to ensure
	# the crop is perfectly centered on the tile. this is more precise
	# and consistent than using player_pos directly.
	crop.global_position = _tile_map.map_to_local(_coords)
	crop.initialize(CropData.new(crop_resource), tile_data.is_watered)

	tile_data.crop_node = crop

# Mark watered tile as unwatered, update the tile visuals,
# 	and adjust crop sprites when required.
func on_day_changed() -> void:
	for cell in _watered_tiles:
		var tile_data := _watered_tiles[cell]
		tile_data.is_watered = false
		
		var index = TILLED_GRASS_INDEX if tile_data.is_tilled else GRASS_INDEX
		_update_tile_map(cell, index)

		if tile_data.has_crop():
			tile_data.crop_node.on_new_day()

	_watered_tiles.clear()

func _get_tile_data_at_pos(player_pos: Vector2) -> GrassTileData:
	_coords = _tile_map.local_to_map(player_pos)
	return _tile_data_at_pos[_coords]

func _update_tile_map(coords: Vector2i, index : int):
	_tile_map.set_cell(coords, index, Vector2i(0, 0))
