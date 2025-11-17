class_name Grass
extends Node2D

# Indices for the tile maps
const GRASS_INDEX = 0
const TILLED_GRASS_INDEX = 1
const TILLED_WATERED_INDEX = 2

var _tile_data_at_pos: Dictionary[Vector2i, GrassTileData]
var _coords : Vector2i

@onready var _tile_map: TileMapLayer = $GrassTileMap
@onready var _player: CharacterBody2D = $"../Player"

func _ready():
	for cell in _tile_map.get_used_cells():
		_tile_data_at_pos[cell] = GrassTileData.new()

func _get_tile_data_at_pos(player_pos) -> GrassTileData:
	_coords = _tile_map.local_to_map(player_pos)
	return _tile_data_at_pos[_coords]

# Till this tile if it doesn't have a crop and is not already tilled
func till_tile():
	var tile_data := _get_tile_data_at_pos(_player.global_position)
	
	if tile_data.has_crop:
		return
	
	if tile_data.is_tilled:
		return
	
	tile_data.is_tilled = true
	_update_tile_map(TILLED_GRASS_INDEX)

# Water this tile only if it's already tilled and not watered
func water_tile():
	var tile_data := _get_tile_data_at_pos(_player.global_position)
	
	if not tile_data.is_tilled:
		return
	
	if tile_data.is_watered:
		return
		
	tile_data.is_watered = true
	if tile_data.has_crop:
		tile_data.crop_data.water()
	
	_update_tile_map(TILLED_WATERED_INDEX)

# Harvest the crop on this tile if one is present
func harvest_tile():
	var tile_data := _get_tile_data_at_pos(_player.global_position)
	
	if not tile_data.has_crop:
		return
		
	if not tile_data.crop_data.can_be_harvested():
		return
	
	tile_data.has_crop = false
	tile_data.crop_data = null
	tile_data.crop_sprite = null
	_update_tile_map(TILLED_GRASS_INDEX)

# Plant a crop on this tile if the soil has been tilled
func plant_tile(crop_resource : CropResource):
	var tile_data := _get_tile_data_at_pos(_player.global_position)
	
	if not tile_data.is_tilled:
		return
	
	tile_data.has_crop = true
	tile_data.crop_data = CropData.new(crop_resource)
	
	if tile_data.is_watered:
		tile_data.crop_data.water()
	
	var crop_sprite: Sprite2D = Sprite2D.new()
	add_child(crop_sprite)
	# Convert tile coordinates back to world position to ensure
	# the crop is perfectly centered on the tile. this is more precise
	# and consistent than using player_pos directly.
	crop_sprite.global_position = _tile_map.map_to_local(_coords)
	crop_sprite.texture = tile_data.crop_data._current_asset
	tile_data.crop_sprite = crop_sprite

func _update_tile_map(index : int):
	_tile_map.set_cell(_coords, index, Vector2i(0, 0))
