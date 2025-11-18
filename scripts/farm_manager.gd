extends Node
class_name FarmManager

@onready var _grass: Node2D = $"Grass"

func _init() -> void:
	pass

func _ready() -> void:
	GameManager.day_changed.connect(_on_day_changed)

func _on_day_changed() -> void:
	_grass.on_day_changed()
