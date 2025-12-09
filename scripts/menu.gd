extends Control

@onready var _exit_button = $ExitButton

func _ready() -> void:
	_exit_button.pressed.connect(_on_exit_button_pressed)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit_game"):
		_quit_game()

func _on_exit_button_pressed() -> void:
	_quit_game()

func _quit_game() -> void:
	# TODO: Add confirmation screen
	get_tree().quit()
