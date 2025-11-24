class_name ItemButton
extends TextureButton

@export var crop_resource : CropResource
@export var tool : ItemData.Tool

var _player_item : ItemData.Item

func _init() -> void:
	pass

func _ready() -> void:
	pressed.connect(_on_mouse_pressed)
	var player_seed = ItemData.Seed.new(crop_resource)
	_player_item = ItemData.Item.new(tool, player_seed)

# Use the item, when there's no tool it means we have a seed
func _on_mouse_pressed() -> void:
	GameManager.select_item(_player_item)
