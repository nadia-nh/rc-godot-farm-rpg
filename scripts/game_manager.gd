extends Node

signal day_changed()
signal item_used()

var _current_day : int
var _current_item : ItemData.Item
var _potato_resource = preload("res://resources/potato_crop.tres")
var _turnip_resource = preload("res://resources/turnip_crop.tres")

func _ready() -> void:
	_current_day = 0
	_current_item = ItemData.Item.new(ItemData.Tool.HOE, null)
	_set_next_day.call_deferred()
	
func get_current_day() -> int:
	return _current_day

func get_current_item() -> ItemData.Item:
	return _current_item

func get_potato_resource() -> CropResource:
	return _potato_resource

func get_turnip_resource() -> CropResource:
	return _turnip_resource

func select_item(item : ItemData.Item) -> void:
	_current_item = item

# Increases the day, and emits the corresponding signal
func _set_next_day():
	_current_day += 1
	day_changed.emit()
