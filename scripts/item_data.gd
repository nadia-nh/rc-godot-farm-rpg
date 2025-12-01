class_name ItemData
## ItemData
##
## Stores the data for a single player item, whether it’s a tool or a seed.

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

	func get_tool() -> Tool:
		return tool_data

	func get_crop_resource() -> CropResource:
		if not is_seed_item():
			return null

		return seed_data.crop_resource

	func is_equal_to(other: Item) -> bool:
		return (constains_tool(other.get_tool()) or
				contains_seed(other.get_crop_resource()))

	func is_tool_item() -> bool:
		return tool_data != Tool.NONE

	func is_seed_item() -> bool:
		return (tool_data == Tool.NONE and
				is_instance_valid(seed_data.crop_resource))

	func constains_tool(tool: Tool) -> bool:
		return (is_tool_item() and tool_data == tool)

	func contains_seed(crop_resource: CropResource) -> bool:
		if not is_seed_item():
			return false
		return seed_data.crop_resource == crop_resource
