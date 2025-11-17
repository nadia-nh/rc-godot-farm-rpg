extends TextureButton

@export var crop_data : CropData
@export var tool : ItemData.Tool

var player_item : ItemData.Item

func _init() -> void:
	var player_seed = ItemData.Seed.new(crop_data)
	player_item = ItemData.Item.new(tool, player_seed)

func _ready() -> void:
	pass

func _on_pressed() -> void:
	pass
