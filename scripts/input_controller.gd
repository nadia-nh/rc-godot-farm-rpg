class_name InputController
extends Node
## InputController
##
## Handles keyboard input and notifies the GameManager about relevant state
## updates, including day changes, item use and selection.

var item_actions : Array[String]
var player_actions : Array[String]

@onready var farm_manager = $"../FarmManager"

func _ready() -> void:
	item_actions = [
		"tool_hoe", "tool_scythe", "tool_water", "seed_potato", "seed_turnip"
	]
	player_actions = [
		"move_left", "move_right", "move_up", "move_down"
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

	for action in player_actions:
		if Input.is_action_just_pressed(action):
			# Gets the inputs and converts them to a direction
			var input_direction = Input.get_vector(
				"move_left", "move_right", "move_up", "move_down")

			if (input_direction != Vector2.ZERO):
				GameManager.player_moved.emit(input_direction)
		if Input.is_action_just_released(action):
			GameManager.player_stopped.emit()
