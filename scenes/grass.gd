class_name Grass
extends Node2D

var _tile_info_at_pos: Dictionary[Vector2i, GrassTileData.Info]
var _coords : Vector2i

@onready var _tile_map: TileMapLayer = $GrassTileMap

func _ready():
	for cell in _tile_map.get_used_cells():
		_tile_info_at_pos[cell] = GrassTileData.Info.new()

func _get_tile_info_at_pos(player_pos) -> GrassTileData.Info:
	_coords = _tile_map.local_to_map(player_pos)
	return _tile_info_at_pos[_coords]

# Till this tile if it doesn't have a crop and is not already tilled
func till_tile():
	var tile_info := _get_tile_info_at_pos(global_position)
	
	if tile_info.hasCrop:
		return
	
	if tile_info.isTilled:
		return
	
	tile_info.isTilled = true

# Water this tile only if it's already tilled and not watered
func water_tile():
	var tile_info := _get_tile_info_at_pos(global_position)
	
	if not tile_info.isTilled:
		return
	
	if tile_info.isWatered:
		return
		
	tile_info.isWatered = true

# Harvest the crop on this tile if one is present
# TODO: add check for harvest readiness
func harvest_tile():
	var tile_info := _get_tile_info_at_pos(global_position)
	
	if not tile_info.hasCrop:
		return
	
	tile_info.hasCrop = false

# Plant a crop on this tile if the soil has been tilled
func plant_tile(crop_resource : CropResource):
	var tile_info := _get_tile_info_at_pos(global_position)
	
	if not tile_info.isTilled:
		return
	
	tile_info.hasCrop = true
	tile_info.cropResource = crop_resource
