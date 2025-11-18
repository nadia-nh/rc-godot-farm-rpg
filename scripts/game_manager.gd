extends Node

signal day_changed()
signal item_used()

var _current_day : int

func _ready() -> void:
	_current_day = 0
	_set_next_day.call_deferred()
	
func get_current_day() -> int:
	return _current_day

# Increases the day, and emits the corresponding signal
func _set_next_day():
	_current_day += 1
	day_changed.emit()
