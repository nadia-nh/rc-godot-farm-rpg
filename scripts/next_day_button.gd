class_name NextDayButton
extends TextureButton
## NextDayButton
##
## Exposes methods that the UILayer calls to update the button’s visuals.

func show_button_selected() -> void:
	self.self_modulate = Color("#F7AC38")

func show_button_unselected() -> void:
	self.self_modulate = Color("#FFFFFF")
