class_name ItemBase
extends StaticBody3D

enum ItemType {INGOT, CRAFTED_RESULT}
enum MetalType {IRON, STEEL, BRONZE, SILVER, GOLD}

# Base item data
var item := "unnamed"
var item_type: ItemType = ItemType.INGOT

# Weapon stats
var strength: float = 0.0
var sharpness: float = 0.0
var balance: float = 0.0
var metal_type: MetalType = MetalType.IRON

const METAL_MODIFIERS: Dictionary = {
	MetalType.IRON:   {"strength": 1.0, "sharpness": 0.8},
	MetalType.STEEL:  {"strength": 1.2, "sharpness": 1.2},
	MetalType.BRONZE: {"strength": 0.8, "sharpness": 0.9},
	MetalType.SILVER: {"strength": 0.6, "sharpness": 1.1},
	MetalType.GOLD:   {"strength": 0.4, "sharpness": 0.7},
}

const SHELF_OFFSETS = {
	"Spear_Head": 0.3,
	"ShortSword_Blade": 0.5,
	"GreatSword_Blade": 0.7
}

func apply_material_modifiers(base_strength: float, base_sharpness: float):
	var mod = METAL_MODIFIERS.get(metal_type, {"strength": 1.0, "sharpness": 1.0})
	strength = base_strength * mod["strength"]
	sharpness = base_sharpness * mod["sharpness"]

func get_average_quality() -> float:
	return (strength + sharpness + balance) / 3.0

func get_price_modifier() -> float:
	return get_average_quality()

func interact():
	var Item_Shelf = get_tree().get_first_node_in_group("ItemShelf")
	var Anvil = get_tree().get_first_node_in_group("Anvil")
	var slot = Item_Shelf.get_free_slot()
	if Item_Shelf == null or slot == null:
		return
	slot["occupant"] = self
	self.reparent(Item_Shelf)
	var down_offset = SHELF_OFFSETS.get(item, 0.3)
	self.global_position = Item_Shelf.global_position + Vector3.UP * Item_Shelf.snap_height + slot["offset"] + Vector3.DOWN * down_offset
	self.rotation_degrees.z = 90.0
	Anvil.clear_result()

func highlight():
	pass

func unhighlight():
	pass
