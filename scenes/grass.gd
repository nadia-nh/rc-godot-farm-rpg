class_name Grass
extends Node2D

var _tile_data_at_pos: Dictionary[Vector2i, GrassTileData]
var _coords : Vector2i

@onready var _tile_map: TileMapLayer = $GrassTileMap

func _ready():
	for cell in _tile_map.get_used_cells():
		_tile_data_at_pos[cell] = GrassTileData.new()

func _get_tile_data_at_pos(player_pos) -> GrassTileData:
	_coords = _tile_map.local_to_map(player_pos)
	return _tile_data_at_pos[_coords]

# Till this tile if it doesn't have a crop and is not already tilled
func till_tile():
	var tile_data := _get_tile_data_at_pos(global_position)
	
	if tile_data.has_crop:
		return
	
	if tile_data.is_tilled:
		return
	
	tile_data.is_tilled = true

# Water this tile only if it's already tilled and not watered
func water_tile():
	var tile_data := _get_tile_data_at_pos(global_position)
	
	if not tile_data.is_tilled:
		return
	
	if tile_data.is_watered:
		return
		
	tile_data.is_watered = true

# Harvest the crop on this tile if one is present
# TODO: add check for harvest readiness
func harvest_tile():
	var tile_data := _get_tile_data_at_pos(global_position)
	
	if not tile_data.has_crop:
		return
	
	tile_data.has_crop = false

# Plant a crop on this tile if the soil has been tilled
func plant_tile(crop_resource : CropResource):
	var tile_data := _get_tile_data_at_pos(global_position)
	
	if not tile_data.is_tilled:
		return
	
	tile_data.has_crop = true
	tile_data.crop_resource = crop_resource
