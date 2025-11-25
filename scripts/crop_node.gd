class_name CropNode
extends Node2D

@onready var sprite = $CropSprite

var _crop_data : CropData
var _current_index : int

func _ready() -> void:
	pass

func initialize(crop_data : CropData, is_tile_watered : bool):
	_crop_data = crop_data
	_crop_data.set_watered(is_tile_watered)
	_current_index = 0
	sprite.texture = _crop_data.get_asset_at_index(_current_index)

func can_be_harvested() -> bool:
	return _current_index >= _crop_data.get_days_to_grow()

func water() -> void:
	_crop_data.set_watered(true)

func on_new_day() -> void:
	if not _crop_data.is_watered():
		return

	_crop_data.set_watered(false)
	_update_sprite_texture()

func clear() -> void:
	sprite.texture = null

func get_crop_resource() -> CropResource:
	if not is_instance_valid(_crop_data):
		return null
	
	return _crop_data._crop_resource

func _update_sprite_texture() -> void:
	if can_be_harvested():
		return

	_current_index += 1
	sprite.texture = _crop_data.get_asset_at_index(_current_index)
