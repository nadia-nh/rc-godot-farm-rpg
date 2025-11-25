extends Node
class_name FarmManager

@onready var _grass: Node2D = $"Grass"

var _potato_resource = preload("res://resources/potato_crop.tres")
var _turnip_resource = preload("res://resources/turnip_crop.tres")
var _items_by_action : Dictionary[String, ItemData.Item]
var _seed_quantities : Dictionary[CropResource, int]

func _init() -> void:
	pass

func _build_item(item_tool, item_seed):
	return ItemData.Item.new(item_tool, item_seed)

func _ready() -> void:
	GameManager.day_changed.connect(_on_day_changed)
	GameManager.item_used.connect(_on_item_used)
	
	var potato_seed = ItemData.Seed.new(_potato_resource)
	var turnip_seed = ItemData.Seed.new(_turnip_resource)
	_items_by_action = {
		"tool_hoe" : _build_item(ItemData.Tool.HOE, null),
		"tool_scythe" : _build_item(ItemData.Tool.SCYTHE, null),
		"tool_water": _build_item(ItemData.Tool.WATER_BUCKET, null),
		"seed_potato": _build_item(ItemData.Tool.NONE, potato_seed),
		"seed_turnip": _build_item(ItemData.Tool.NONE, turnip_seed)
	}
	_seed_quantities = {
		_potato_resource : 2,
		_turnip_resource : 2
	}

func get_item_from_action(action: String) -> ItemData.Item:
	if not action in _items_by_action.keys():
		return null

	return _items_by_action[action]

func can_plant_crop(crop: CropResource) -> bool:
	if not crop in _seed_quantities.keys():
		return false

	return _seed_quantities[crop] > 0

func use_seed(crop: CropResource) -> void:
	if not crop in _seed_quantities.keys():
		return

	_seed_quantities[crop] -= 1
	GameManager.seed_quantity_updated.emit(crop, _seed_quantities[crop])

func _on_day_changed() -> void:
	_grass.on_day_changed()

func _on_item_used() -> void:
	var item = GameManager.get_current_item()
	match item.tool_data:
		ItemData.Tool.HOE:
			_grass.till_tile()
		ItemData.Tool.SCYTHE:
			_grass.harvest_tile()
		ItemData.Tool.WATER_BUCKET:
			_grass.water_tile()
		ItemData.Tool.NONE:
			if can_plant_crop(item.seed_data.crop_resource):
				_grass.plant_tile(item.seed_data.crop_resource)
