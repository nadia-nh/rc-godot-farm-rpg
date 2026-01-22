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

var _crop_scene: PackedScene = preload("res://scenes/crop_node.tscn")
var _tile_state_at_pos: Dictionary[Vector2i, GrassTileState]
var _watered_tiles : Dictionary[Vector2i, GrassTileState]

@onready var _tile_map: TileMapLayer = $GrassTileMap

func _ready():
	assert(_crop_scene != null, "Crop scene failed to load")

	for cell in _tile_map.get_used_cells():
		_tile_state_at_pos[cell] = GrassTileState.new()

# Returns true if the tile was tilled / untilled
# This happens when the tile doesn't have a crop
func till_tile(player_pos: Vector2) -> bool:
	var coords := _get_coords_from_pos(player_pos)
	var tile_state := _get_tile_data_at_coords(coords)

	if tile_state.has_crop():
		return false

	if tile_state.is_tilled:
		tile_state.is_tilled = false
		_update_tile_map(coords, GRASS_INDEX)
		return true

	tile_state.is_tilled = true
	_update_tile_map(coords, TILLED_GRASS_INDEX)
	return true

# Returns true if the tile was watered
# This happens when the tile is already tilled and not watered
func water_tile(player_pos: Vector2) -> bool:
	var coords := _get_coords_from_pos(player_pos)
	var tile_state := _get_tile_data_at_coords(coords)

	if not tile_state.is_tilled:
		return false

	if tile_state.is_watered:
		return false

	if tile_state.has_crop():
		tile_state.crop_node.water()

	tile_state.is_watered = true

	_watered_tiles[coords] = tile_state
	_update_tile_map(coords, TILLED_WATERED_INDEX)
	return true

# Harvest the crop on this tile if one is present
func harvest_tile(player_pos: Vector2) -> bool:
	var coords := _get_coords_from_pos(player_pos)
	var tile_state := _get_tile_data_at_coords(coords)

	if not tile_state.has_crop():
		return false

	if not tile_state.crop_node.can_be_harvested():
		return false

	tile_state.crop_node.clear()
	tile_state.crop_node = null
	_watered_tiles.erase(coords)
	return true

# Plant a crop on this tile if the soil has been tilled and there's no crop
func plant_tile(crop_resource : CropResource, player_pos: Vector2) -> bool:
	var coords := _get_coords_from_pos(player_pos)
	var tile_state := _get_tile_data_at_coords(coords)

	if not tile_state.is_tilled:
		return false

	if tile_state.has_crop():
		return false

	var crop: CropNode = _crop_scene.instantiate()
	add_child(crop)
	# Convert tile coordinates back to world position to ensure
	# the crop is perfectly centered on the tile. this is more precise
	# and consistent than using player_pos directly.
	crop.global_position = _tile_map.map_to_local(coords)
	crop.initialize(crop_resource, tile_state.is_watered)

	tile_state.crop_node = crop
	return true

# Mark watered tile as unwatered, update the tile visuals,
# 	and adjust crop sprites when required.
func on_day_changed() -> void:
	for cell in _watered_tiles:
		var tile_state := _watered_tiles[cell]
		tile_state.is_watered = false
		
		var index = TILLED_GRASS_INDEX if tile_state.is_tilled else GRASS_INDEX
		_update_tile_map(cell, index)

		if tile_state.has_crop():
			tile_state.crop_node.on_new_day()

	_watered_tiles.clear()

func get_crop_resource_at_pos(player_pos: Vector2) -> CropResource:
	var coords := _get_coords_from_pos(player_pos)
	var tile_state := _get_tile_data_at_coords(coords)
	var crop_node := tile_state.crop_node
	return crop_node.get_crop_resource() if is_instance_valid(crop_node) else null

func _get_coords_from_pos(player_pos: Vector2) -> Vector2i:
	return _tile_map.local_to_map(player_pos)

func _get_tile_data_at_coords(coords: Vector2i) -> GrassTileState:
	return _tile_state_at_pos[coords]

func _update_tile_map(coords: Vector2i, index : int):
	_tile_map.set_cell(coords, index, Vector2i(0, 0))
