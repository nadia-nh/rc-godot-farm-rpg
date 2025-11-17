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
	var crop_resource: CropResource
	
	func _init(resource: CropResource):
		crop_resource = resource

# Represents any item the player can hold, either a tool or a seed.
class Item:
	var tool_data: Tool
	var seed_data: Seed
	
	func _init(_tool: Tool, _seed: Seed):
		tool_data = _tool
		seed_data = _seed
