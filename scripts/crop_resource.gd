# Stores buy / sell prices for a crop type, and its visual assets.
class_name CropResource
extends Resource

@export var crop_assets: Array[Texture]
@export var crop_name: String
@export var seed_price: int = 10
@export var sell_price: int = 20
