extends TextureButton

@export var crop_data : CropData
@export var tool : ItemData.Tool

var _player_item : ItemData.Item

@onready var _grass := $"../../../Grass"

func _init() -> void:
	var player_seed = ItemData.Seed.new(crop_data)
	_player_item = ItemData.Item.new(tool, player_seed)

func _ready() -> void:
	pass

# Use the item, when there's no tool it means we have a seed
func _on_pressed() -> void:
	match _player_item.toolData:
		ItemData.Tool.HOE:
			_grass.till_tile()
		ItemData.Tool.SCYTHE:
			_grass.harvest_tile()
		ItemData.Tool.WATER_BUCKET:
			_grass.water_tile()
		ItemData.Tool.NONE:
			_grass.plant_tile(crop_data)
