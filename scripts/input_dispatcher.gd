extends Node

func _ready() -> void:
	pass

func _physics_process(_delta):
	if Input.is_action_pressed("next_day"):
		GameManager.day_changed.emit()
