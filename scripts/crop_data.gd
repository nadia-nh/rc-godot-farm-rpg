# Holds the state for a crop on a tile
# Tracks its resource data, watering status, growth progress, and current visual asset
class_name CropData

var _crop_resource : CropResource
var _is_watered : bool
var _days_to_grow : int
var _current_asset : Texture
var _current_index : int

func _init(resource : CropResource) -> void:
	_crop_resource = resource
	_is_watered = false
	_days_to_grow = _crop_resource.crop_assets.size()
	_current_asset =_crop_resource.crop_assets[0]

func water() -> void:
	_is_watered = true
	
func is_watered() -> bool:
	return _is_watered
	
func advance_day() -> void:
	if is_watered():
		_update_asset()
		_days_to_grow -= 1
		_is_watered = false

func can_be_harvested() -> bool:
	return _days_to_grow == 0

func _update_asset():
	if _days_to_grow <= 0:
		return

	_current_index += 1
	_current_asset = _crop_resource.crop_assets[_current_index]
