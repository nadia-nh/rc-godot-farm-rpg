extends Node
## GameManager
##
## Autoload singleton that manages core game state: current day, player money,
## and selected item. Declares signals for global use and emits the ones
## tied to day, money, and item selected changes.

# Day Signals
signal day_changed()

# Money and Seed Quantity Signals
signal money_updated(quantity: int)
@warning_ignore("unused_signal")
signal seed_quantity_updated(crop_resource_for_seed: CropResource, quantity: int)

# Item Signals
@warning_ignore("unused_signal")
signal item_used()
signal item_selected(item: ItemData.Item)

# Player Movement Signals
@warning_ignore("unused_signal")
signal player_moved(input_direction: Vector2)
@warning_ignore("unused_signal")
signal player_stopped()

const MAX_DAILY_ACTIONS: int = 5

var _current_day : int
var _current_money : int
var _current_item : ItemData.Item
var _daily_actions_left: int = 0

func _ready() -> void:
	item_selected.connect(_on_item_selected)
	day_changed.connect(_on_day_changed)

	_current_money = 0
	_change_money.call_deferred(20)
	_current_day = 0
	_set_next_day.call_deferred()
	_set_item.call_deferred(ItemData.Item.new(ItemData.Tool.HOE, null))

func get_current_day() -> int:
	return _current_day

func get_current_item() -> ItemData.Item:
	return _current_item

func add_money(money: int) -> void:
	_change_money(money)

func can_spend_money(amount: int) -> bool:
	return _current_money >= amount

func spend_money(amount: int) -> void:
	if not can_spend_money(amount):
		return

	_change_money(amount * -1)

# Checks whether the player can consume one of the daily actions
func can_consume_action():
	return _daily_actions_left > 0

# Uses up one of the daily actions and updates the UI
func consume_daily_action():
	if not can_consume_action():
		return
	
	_daily_actions_left -= 1

func _on_item_selected(item : ItemData.Item) -> void:
	_current_item = item

func _set_item(item : ItemData.Item) -> void:
	item_selected.emit(item)

# Increases the day, and resets daily actions
func _on_day_changed() -> void:
	_current_day += 1
	_daily_actions_left = MAX_DAILY_ACTIONS

# Emits the day_changed signal
func _set_next_day() -> void:
	day_changed.emit()

# Changes the money by the given amount, and emits the corresponding signal
func _change_money(amount: int) -> void:
	_current_money += amount
	money_updated.emit(_current_money)
