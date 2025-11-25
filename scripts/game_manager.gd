extends Node

signal day_changed()
@warning_ignore("unused_signal")
signal item_used()
signal item_selected(item: ItemData.Item)
@warning_ignore("unused_signal")
signal seed_quantity_updated(cropResource: CropResource, quantity: int)

var _current_day : int
var _current_item : ItemData.Item

func _ready() -> void:
	item_selected.connect(_on_item_selected)

	_current_day = 0
	_set_next_day.call_deferred()
	_set_item.call_deferred(ItemData.Item.new(ItemData.Tool.HOE, null))

func get_current_day() -> int:
	return _current_day

func get_current_item() -> ItemData.Item:
	return _current_item

func _on_item_selected(item : ItemData.Item) -> void:
	_current_item = item

func _set_item(item : ItemData.Item) -> void:
	item_selected.emit(item)

# Increases the day, and emits the corresponding signal
func _set_next_day():
	_current_day += 1
	day_changed.emit()
