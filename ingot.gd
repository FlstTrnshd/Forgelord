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
@export var carriable: bool = true

var item_type
var item: String = "Ingot"

func _ready():
	item = MetalType.keys()[metal_type].capitalize() + " Ingot"

func get_display_name() -> String:
	return item

func get_modifier() -> float:
	return purity

func can_carry() -> bool:
	return carriable

func highlight():
	pass

func unhighlight():
	pass
