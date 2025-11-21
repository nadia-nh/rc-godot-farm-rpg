class_name GrassTileData

var is_watered : bool
var is_tilled : bool
var crop_node : CropNode

func _init() -> void:
	is_watered = false
	is_tilled = false
	crop_node = null

func has_crop() -> bool:
	return is_instance_valid(crop_node)
	
