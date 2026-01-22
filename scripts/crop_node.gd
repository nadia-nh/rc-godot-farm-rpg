class_name CropNode
extends Node2D
## CropNode
##
## Handles crop growth and state, updates the sprite when needed.

var _crop_resource : CropResource
var _current_index : int
var _days_to_grow : int
var _is_watered : bool

@onready var sprite = $CropSprite

func _ready() -> void:
	pass

func initialize(crop_resource: CropResource, is_tile_watered : bool):
	var crop_name = crop_resource.crop_name
	assert(crop_resource.crop_assets.size() > 0,
		"The " + crop_name + " crop resource doesn't have any crop assets")
	_crop_resource = crop_resource
	_days_to_grow = _crop_resource.crop_assets.size() - 1
	_is_watered = is_tile_watered
	_current_index = 0
	sprite.texture = _get_asset_at_index(_current_index)

func can_be_harvested() -> bool:
	return _current_index >= _days_to_grow

func water() -> void:
	_is_watered = true

func on_new_day() -> void:
	if not _is_watered:
		return

	_is_watered = false
	_update_sprite_texture()

func clear() -> void:
	sprite.texture = null

func get_crop_resource() -> CropResource:
	return _crop_resource

func _update_sprite_texture() -> void:
	if can_be_harvested():
		return

	_current_index += 1
	sprite.texture = _get_asset_at_index(_current_index)

func _get_asset_at_index(index : int) -> Texture:
	if index > _days_to_grow:
		return null

	return _crop_resource.crop_assets[index]
