extends Node

const WEAPONS: Dictionary = {
	"Spear_Head": preload("res://spear_head.tres"),
	"ShortSword_Blade": preload("res://short_sword.tres"),
	"GreatSword_Blade": preload("res://great_sword.tres"),
}

const INGOT_SCENES: Dictionary = {
	"Iron_Ingot": preload("res://ingot.tscn")
}

func spawn_weapon(pos: Vector3, item_name: String, metal_type: ItemBase.MetalType):
	if not WEAPONS.has(item_name):
		push_error("No weapon data found for: " + item_name)
		return
	var anvil = get_tree().get_first_node_in_group("Anvil")
	if anvil == null:
		push_error("No Anvil found in scene")
		return
	var item = WEAPONS[item_name].instantiate()
	anvil.add_child(item)
	item.global_position = pos
	item.metal_type = metal_type

func spawn_ingot(pos: Vector3, item_name: String, metal_type: ItemBase.MetalType):
	if not INGOT_SCENES.has(item_name):
		push_error("No ingot scene found for: " + item_name)
		return
	var iron_shelf = get_tree().get_first_node_in_group("iron_shelf")
	if iron_shelf == null:
		push_error("No iron shelf found in scene")
		return
	var item = INGOT_SCENES[item_name].instantiate()
	iron_shelf.add_child(item)
	item.global_position = pos
	item.metal_type = metal_type
