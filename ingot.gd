class_name Ingot
extends StaticBody3D

enum MetalType {
	IRON,
	STEEL,
	BRONZE,
	SILVER,
	GOLD
}

@export var metal_type: MetalType = MetalType.IRON
@export var purity: float = 1.0

var item_type
var item: String = "Ingot"

func _ready():
	item = MetalType.keys()[metal_type].capitalize() + " Ingot"

func get_display_name() -> String:
	return item

func get_modifier() -> float:
	return purity

func interact():
	var anvil = get_tree().get_first_node_in_group("Anvil")
	if anvil == null:
		return
	if anvil.has_crafted_result():
		print("Clear the anvil first!")
		return
	var slot = anvil.get_free_slot()
	if slot == null:
		print("Anvil is full!")
		return
	slot["occupant"] = self
	self.global_position = anvil._anvil.global_position + Vector3.UP * anvil.snap_height + slot["offset"]
	anvil.update_hammer()
