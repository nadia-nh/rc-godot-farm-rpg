class_name NextDayButton
extends TextureButton
## NextDayButton
##
## Emits the request to advance the day, and exposes methods that the
## UILayer calls to update the button’s visuals.

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	GameManager.day_changed.emit()

func show_button_selected() -> void:
	self.self_modulate = Color("#F7AC38")

func show_button_unselected() -> void:
	self.self_modulate = Color("#FFFFFF")
