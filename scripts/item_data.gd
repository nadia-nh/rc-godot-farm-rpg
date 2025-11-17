# Contains data structures for tools and seed items
class_name ItemData

# Represents the different tools the player can use.
# NONE is used when no tool is selected.
enum Tool {
	HOE = 0,
	SCYTHE = 1,
	WATER_BUCKET = 2,
	NONE = 3,
}

# Represents a seed item that can be planted.
class Seed:
	var crop: CropData
	
	func _init(_crop: CropData):
		crop = _crop

# Represents any item the player can hold, either a tool or a seed.
class Item:
	var toolData: Tool
	var seedData: Seed
	
	func _init(_tool: Tool, _seed: Seed):
		toolData = _tool
		seedData = _seed
