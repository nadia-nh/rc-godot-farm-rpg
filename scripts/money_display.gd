extends TextureRect

@onready var money_text = $MoneyText

func _ready() -> void:
	GameManager.money_updated.connect(_on_money_updated)

func _on_money_updated(quantity: int) -> void:
	money_text.text = str(quantity)
