class_name UIManager
extends CanvasLayer
## UIManager
##
## Handles UI updates for the item buttons and the next-day button.
## Makes sure the item buttons visually reflect the selected tool, and
## updates the next-day button to show when it has been pressed.

var _item_buttons : Array[ItemButton]
var _selected_item : ItemData.Item

@onready var buttons_container = $ItemButtonContainer
@onready var next_day_button = $NextDayButton
@onready var money_display = $MoneyDisplay
@onready var day_night_overlay = $DayNightOverlay

func _ready() -> void:
	if GameManager.in_panting_mode():
		_hide_ui_elements()
	else:
		_connect_to_signals()
		_initialize_buttons()

func _connect_to_signals() -> void:
	GameManager.item_selected.connect(_on_item_selected)
	GameManager.day_changed.connect(_on_day_changed)
	GameManager.day_advanced.connect(_on_day_advanced)
	GameManager.money_updated.connect(_on_money_updated)
	GameManager.seed_quantity_updated.connect(_on_seed_quantity_updated)
	GameManager.seed_purchase_attempted.connect(_on_seed_purchase_attempted)
	next_day_button.pressed.connect(_on_next_day_pressed)

func _initialize_buttons() -> void:
	for child in buttons_container.get_children():
		if child is ItemButton:
			_item_buttons.append(child)
			child.pressed.connect(_on_item_pressed.bind(child))

func _hide_ui_elements() -> void:
	buttons_container.visible = false
	next_day_button.visible = false
	money_display.visible = false

func _on_item_selected(item: ItemData.Item) -> void:
	_selected_item = item
	_set_player_item_colors()

func _set_player_item_colors() -> void:
	if not is_instance_valid(_selected_item):
		return

	for button in _item_buttons:
		if _button_has_item(button, _selected_item):
			button.show_button_selected()
		else:
			button.show_button_unselected()

# Show that the next day button has been pressed, and reset the
# colors on the buttons
func _on_day_changed() -> void:
	next_day_button.show_button_selected()
	var timer = get_tree().create_timer(0.1)
	timer.timeout.connect(next_day_button.show_button_unselected)

	_set_player_item_colors()

# Update the day night overlay transparency, if it's night show
# the button as disabled
func _on_day_advanced(progress: float):
	day_night_overlay.color.a = progress * 0.5

	if progress == 1.0:
		for button in _item_buttons:
			button.self_modulate = Color.LIGHT_GRAY

func _on_money_updated(quantity: int) -> void:
	money_display.update_money(quantity)

func _on_seed_quantity_updated(
	crop_resource_for_seed: CropResource, quantity: int) -> void:
	for button in _item_buttons:
		var item = button.get_item()
		if item.contains_seed(crop_resource_for_seed):
			if quantity <= 0:
				var seed_price = item.get_crop_resource().seed_price
				button.update_price_text(seed_price)
			else:
				button.update_quantity_text(quantity)

# Inform game manager that the item was selected
func _on_item_pressed(button: ItemButton) -> void:
	GameManager.item_selected.emit(button.get_item())

# Inform game manager that the day has changed
func _on_next_day_pressed() -> void:
	GameManager.day_changed.emit()

func _button_has_item(button: ItemButton, item: ItemData.Item) -> bool:
	return button.get_item().is_equal_to(item)

func _on_seed_purchase_attempted(
	crop_resource_for_seed: CropResource, bought: bool) -> void:
	for button in _item_buttons:
		var item = button.get_item()
		if item.contains_seed(crop_resource_for_seed):
			_show_button_action_feedback(button, bought)

func _show_button_action_feedback(button: ItemButton, success: bool) -> void:
	if success:
		button.show_button_action_success()
	else:
		button.show_button_action_failure()
	
	var timer = get_tree().create_timer(0.1)
	timer.timeout.connect(button.show_button_selected)
