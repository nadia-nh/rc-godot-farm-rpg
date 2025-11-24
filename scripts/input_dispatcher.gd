extends Node

func _ready() -> void:
	pass

func _physics_process(_delta):
	if Input.is_action_just_pressed("next_day"):
		GameManager.day_changed.emit()
	if Input.is_action_just_pressed("use_item"):
		GameManager.item_used.emit()
	
	if Input.is_action_just_pressed("tool_hoe"):
		_select_item(ItemData.Tool.HOE, null)
	elif Input.is_action_just_pressed("tool_scythe"):
		_select_item(ItemData.Tool.SCYTHE, null)
	elif Input.is_action_just_pressed("tool_water"):
		_select_item(ItemData.Tool.WATER_BUCKET, null)
	elif Input.is_action_just_pressed("seed_potato"):
		_select_item(
			ItemData.Tool.NONE,
			ItemData.Seed.new(GameManager.get_potato_resource()))
	elif Input.is_action_just_pressed("seed_turnip"):
		_select_item(
			ItemData.Tool.NONE,
			ItemData.Seed.new(GameManager.get_turnip_resource()))

func _select_item(item_tool, item_seed):
	var item = ItemData.Item.new(item_tool, item_seed)
	GameManager.item_selected.emit(item)
