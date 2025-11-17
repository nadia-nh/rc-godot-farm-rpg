class_name GrassTileData

var is_watered : bool
var is_tilled : bool
var crop_data : CropData
var crop_sprite: Sprite2D

func _init() -> void:
	is_watered = false
	is_tilled = false
	crop_data = null
	crop_sprite = null

func has_crop() -> bool:
	return is_instance_valid(crop_data)
	
