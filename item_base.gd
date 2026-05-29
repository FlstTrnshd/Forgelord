class_name ItemBase
extends StaticBody3D

enum ItemType {INGOT, CRAFTED_RESULT}
enum MetalType {IRON, STEEL, BRONZE, SILVER, GOLD}

var item := "unnamed"
var item_type: ItemType = ItemType.INGOT

@export var carriable: bool = true

func can_carry() -> bool:
	return carriable

var strength: float = 0.0
var edge: float = 0.0
var balance: float = 0.0
var metal_type: MetalType = MetalType.IRON

const METAL_MODIFIERS: Dictionary = {
	MetalType.IRON:   {"strength": 1.0, "edge": 0.8},
	MetalType.STEEL:  {"strength": 1.2, "edge": 1.2},
	MetalType.BRONZE: {"strength": 0.8, "edge": 0.9},
	MetalType.SILVER: {"strength": 0.6, "edge": 1.1},
	MetalType.GOLD:   {"strength": 0.4, "edge": 0.7},
}

const SHELF_OFFSETS = {
	"Spear_Head": 0.3,
	"ShortSword_Blade": 0.5,
	"GreatSword_Blade": 0.7
}

func apply_material_modifiers(base_strength: float, base_edge: float):
	var mod = METAL_MODIFIERS.get(metal_type, {"strength": 1.0, "edge": 1.0})
	strength = base_strength * mod["strength"]
	edge = base_edge * mod["edge"]

func get_average_quality() -> float:
	return (strength + edge + balance) / 3.0

func get_price_modifier() -> float:
	return get_average_quality()

func highlight():
	pass

func unhighlight():
	pass
