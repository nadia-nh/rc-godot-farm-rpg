class_name InputDispatcher
extends Node
## InputDispatcher
##
## Handles keyboard input and notifies the GameManager about relevant state
## updates, including day changes, item use and selection.

var item_actions : Array[String]

@onready var farm_manager = $"../FarmManager"

func _ready() -> void:
	item_actions = [
	"tool_hoe", "tool_scythe", "tool_water", "seed_potato", "seed_turnip"
]

func _physics_process(_delta):
	if Input.is_action_just_pressed("next_day"):
		GameManager.day_changed.emit()
	if Input.is_action_just_pressed("use_item"):
		GameManager.item_used.emit()

	for action in item_actions:
		if Input.is_action_just_pressed(action):
			GameManager.item_selected.emit(
				farm_manager.get_item_from_action(action))
