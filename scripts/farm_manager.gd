extends Node
class_name FarmManager
## FarmManager
##
## Handles the high-level interaction between the Player and the GrassLand.
## Tracks seed quantities for each crop and determines whether a crop can be
## planted or a new seed can be bought.

var _potato_resource = preload("res://resources/potato_crop.tres")
var _turnip_resource = preload("res://resources/turnip_crop.tres")
var _items_by_action : Dictionary[String, ItemData.Item]
var _seed_quantities : Dictionary[CropResource, int]

@onready var _grassland: Node2D = $"GrassLand"
@onready var _player: CharacterBody2D = $"Player"

func _init() -> void:
	pass

func _ready() -> void:
	GameManager.day_changed.connect(_on_day_changed)
	GameManager.item_used.connect(_on_item_used)
	GameManager.player_moved.connect(_on_player_moved)
	GameManager.player_stopped.connect(_on_player_stopped)

	var potato_seed = ItemData.Seed.new(_potato_resource)
	var turnip_seed = ItemData.Seed.new(_turnip_resource)
	_items_by_action = {
		"tool_hoe" : _build_item(ItemData.Tool.HOE, null),
		"tool_scythe" : _build_item(ItemData.Tool.SCYTHE, null),
		"tool_water": _build_item(ItemData.Tool.WATER_BUCKET, null),
		"seed_potato": _build_item(ItemData.Tool.NONE, potato_seed),
		"seed_turnip": _build_item(ItemData.Tool.NONE, turnip_seed)
	}
	_init_seed_quantities()

func get_item_from_action(action: String) -> ItemData.Item:
	if not action in _items_by_action.keys():
		return null

	return _items_by_action[action]

func can_use_crop_seed(crop: CropResource) -> bool:
	if not crop in _seed_quantities.keys():
		return false

	return _seed_quantities[crop] > 0

func use_seed(crop: CropResource) -> void:
	if not crop in _seed_quantities.keys():
		return

	_seed_quantities[crop] -= 1
	GameManager.seed_quantity_updated.emit(crop, _seed_quantities[crop])

func sell_crop(crop: CropResource) -> void:
	if is_instance_valid(crop):
		GameManager.add_money(crop.sell_price)

func can_buy_seed(crop: CropResource) -> bool:
	if not is_instance_valid(crop):
		return false

	return GameManager.can_spend_money(crop.seed_price)

func buy_seed(crop: CropResource) -> void:
	if not is_instance_valid(crop):
		return

	GameManager.spend_money(crop.seed_price)
	_seed_quantities[crop] += 1
	GameManager.seed_quantity_updated.emit(crop, _seed_quantities[crop])

func _init_seed_quantities() -> void:
	_seed_quantities = {
		_potato_resource : 2,
		_turnip_resource : 2
	}

	for crop_resource_for_seed in _seed_quantities:
		GameManager.seed_quantity_updated.emit(
			crop_resource_for_seed, _seed_quantities[crop_resource_for_seed])

func _build_item(item_tool, item_seed):
	return ItemData.Item.new(item_tool, item_seed)

func _on_day_changed() -> void:
	_grassland.on_day_changed()

func _on_item_used() -> void:
	if not GameManager.can_consume_action():
		return

	var item = GameManager.get_current_item()
	var player_pos = _player.get_position()
	match item.tool_data:
		ItemData.Tool.HOE:
			if _grassland.till_tile(player_pos):
				GameManager.consume_daily_action()
		ItemData.Tool.SCYTHE:
			var crop = _grassland.get_crop_resource_at_pos(player_pos)
			if _grassland.harvest_tile(player_pos):
				sell_crop(crop)
				GameManager.consume_daily_action()
		ItemData.Tool.WATER_BUCKET:
			if _grassland.water_tile(player_pos):
				GameManager.consume_daily_action()
		ItemData.Tool.NONE:
			var crop = item.get_crop_resource()
			if can_use_crop_seed(crop):
				if _grassland.plant_tile(crop, player_pos):
					use_seed(crop)
					GameManager.consume_daily_action()
			elif can_buy_seed(crop):
				buy_seed(crop)
				GameManager.seed_purchase_attempted.emit(crop, true)
			else:
				GameManager.seed_purchase_attempted.emit(crop, false)

func _on_player_moved(input_direction: Vector2) -> void:
	_player.update_input_direction(input_direction)

func _on_player_stopped() -> void:
	_player.stop_moving()
