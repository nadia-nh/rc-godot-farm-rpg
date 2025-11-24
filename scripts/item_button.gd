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

func show_button_selected() -> void:
	self.self_modulate = Color("#F7AC38")

func show_button_unselected() -> void:
	self.self_modulate = Color("#FFFFFF")

# Use the item, when there's no tool it means we have a seed
func _on_mouse_pressed() -> void:
	GameManager.item_selected.emit(_player_item)
