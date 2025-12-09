extends Control

@onready var _exit_button = $ExitButton

func _ready() -> void:
	_exit_button.pressed.connect(_on_exit_button_pressed)

func _on_exit_button_pressed() -> void:
	# TODO: Add confirmation screen
	get_tree().quit()
