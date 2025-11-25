extends CanvasLayer

var item_buttons : Array[ItemButton]

@onready var buttons_container = $ItemButtonContainer
@onready var next_day_button = $NextDayButton

func _ready() -> void:
	GameManager.item_selected.connect(_on_item_selected)
	GameManager.day_changed.connect(_on_day_changed)

	for child in buttons_container.get_children():
		if child is ItemButton:
			item_buttons.append(child)

func _on_item_selected(item: ItemData.Item) -> void:
	for button in item_buttons:
		if _button_has_item(button, item):
			button.show_button_selected()
		else:
			button.show_button_unselected()

func _on_day_changed() -> void:
	next_day_button.show_button_selected()
	var timer = get_tree().create_timer(0.1)
	timer.timeout.connect(next_day_button.show_button_unselected)

func _button_has_item(button: ItemButton, item: ItemData.Item) -> bool:
	return (_button_has_same_tool(button, item) and
			_button_has_same_seed(button, item))

func _button_has_valid_seed(button: ItemButton) -> bool:
	return (button.tool == ItemData.Tool.NONE and
			is_instance_valid(button.crop_resource))

func _button_has_seed(button: ItemButton, crop_resource: CropResource) -> bool:
	return (_button_has_valid_seed(button) and
			button.crop_resource == crop_resource)

func _button_has_same_tool(button: ItemButton, item: ItemData.Item) -> bool:
	return button.tool == item.tool_data

func _button_has_same_seed(button: ItemButton, item: ItemData.Item) -> bool:
	if (item.tool_data != ItemData.Tool.NONE):
		return true
	
	return _button_has_seed(button, item.seed_data.crop_resource)
