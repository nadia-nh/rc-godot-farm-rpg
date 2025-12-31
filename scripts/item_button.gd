class_name ItemButton
extends TextureButton
## ItemButton
##
## Uses exported crop resource and tool data to build its item. Updates seed
## quantity text via the relevant signal, notifies the GameManager when
## selected, and provides visual update methods for the UILayer.

@export var crop_resource : CropResource
@export var tool : ItemData.Tool

var _player_item : ItemData.Item

@onready var quantity_text : Label = $Text

func _init() -> void:
	pass

func _ready() -> void:
	var player_seed = ItemData.Seed.new(crop_resource)
	_player_item = ItemData.Item.new(tool, player_seed)

func get_item() -> ItemData.Item:
	return _player_item

func show_button_selected() -> void:
	self.self_modulate = Color("#F7AC38")

func show_button_unselected() -> void:
	self.self_modulate = Color("#FFFFFF")

func update_quantity_text(quantity: int) -> void:
	quantity_text.text = str(quantity)

func update_price_text(price: int) -> void:
	quantity_text.text = "$" + str(price)
