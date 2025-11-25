class_name CropData
## CropData
##
## Holds the state of a crop on a tile, including its resource data and
## whether it has been watered.

var _crop_resource : CropResource
var _is_watered : bool
var _days_to_grow : int

func _init(resource : CropResource) -> void:
	_crop_resource = resource
	_is_watered = false
	_days_to_grow = _crop_resource.crop_assets.size() - 1

func set_watered(watered: bool) -> void:
	_is_watered = watered

func is_watered() -> bool:
	return _is_watered

func get_asset_at_index(index : int) -> Texture:
	if index > _days_to_grow:
		return null

	return _crop_resource.crop_assets[index]

func get_days_to_grow() -> int:
	return _days_to_grow
