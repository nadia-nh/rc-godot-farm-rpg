extends Control

@onready var _main_scene : PackedScene = preload("res://scenes/main.tscn")
@onready var _continue_button = $ContinueButton
@onready var _exit_button = $ExitButton

func _ready() -> void:
	_continue_button.pressed.connect(_on_continue_button_pressed)
	_exit_button.pressed.connect(_on_exit_button_pressed)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit_game"):
		_quit_game()

func _on_continue_button_pressed() -> void:
	# TODO: Make transition faster
	get_tree().change_scene_to_packed(_main_scene)

func _on_exit_button_pressed() -> void:
	_quit_game()

func _quit_game() -> void:
	# TODO: Add confirmation screen
	get_tree().quit()
