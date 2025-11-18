extends Node
class_name FarmManager

@onready var _grass: Node2D = $"Grass"

func _init() -> void:
	pass

func _ready() -> void:
	GameManager.day_changed.connect(_on_day_changed)
	GameManager.item_used.connect(_on_item_used)

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
			_grass.plant_tile(item.seed_data.crop_resource)
