class_name MoneyDisplay
extends TextureRect
## MoneyDisplay
##
## Updates the displayed money amount when the player's money changes.

const MAX_QUANTITY: int = 10_000_000

@onready var money_text = $MoneyText

func _ready() -> void:
	pass

# Shows the player's money (capped at 10 million) and formats it so
# the text fits within the width of the asset.
func update_money(quantity: int) -> void:
	var num = min(quantity, MAX_QUANTITY)
	var millions = num / 1_000_000.0
	var thousands = num / 1_000.0
	var text = "$"

	if num == MAX_QUANTITY:
		text += "10m"
	elif millions >= 1:
		text += str(millions).pad_decimals(1) + "m"
	elif thousands > 9:
		text += str(int(thousands)) + "k"
	elif thousands > 1:
		text += str(thousands).pad_decimals(1) + "k"
	else:
		text += str(quantity)

	money_text.text = text
	_show_money_updated()

func _show_money_updated() -> void:
	_highlight_money_display()
	var timer = get_tree().create_timer(0.1)
	timer.timeout.connect(_unhighlight_money_display)

func _highlight_money_display() -> void:
	self.self_modulate = Color("#F7AC38")

func _unhighlight_money_display() -> void:
	self.self_modulate = Color("#FFFFFF")
