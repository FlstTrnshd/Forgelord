# anvil.gd
extends StaticBody3D

var snap_height := 0.6
var _anvil: Node3D = null  # 👈 Class variable
var slots = [
	{"offset": Vector3(-0.5, 0.0, 0.0), "occupant": null},
	{"offset": Vector3(0.0, 0.0, 0.0), "occupant": null},
	{"offset": Vector3(0.5, 0.0, 0.0), "occupant": null}
]
var recipes = {
	1: "Spear_Head",
	2: "ShortSword_Blade",
	3: "GreatSword_Blade"
}

func _ready():
	_anvil = $Anvil  # 👈 Assign here
	$CraftIcon.hide()
	$CraftIcon/SubViewportContainer.hide()

func get_free_slot():
	for slot in slots:
		if slot["occupant"] == null:
			return slot
	return null

func get_occupied_count():
	var count = 0
	for slot in slots:
		if slot["occupant"] != null:
			count += 1
	return count

func has_crafted_result() -> bool:
	for child in get_children():
		if child is ItemBase and child.item_type == ItemBase.ItemType.CRAFTED_RESULT:
			return true
	return false

func clear_result():
	for child in get_children():
		if child is ItemBase and child.item_type == ItemBase.ItemType.CRAFTED_RESULT:
			child.queue_free()

func update_hammer():
	var count = get_occupied_count()
	if recipes.has(count):
		$CraftIcon.show()
	else:
		$CraftIcon.hide()
		$CraftIcon/SubViewportContainer.hide()

func hammer_clicked():
	var count = get_occupied_count()
	if recipes.has(count):
		$CraftIcon/SubViewportContainer.show()
		$CraftIcon/SubViewportContainer/CraftPanel/OptionButton.clear()
		$CraftIcon/SubViewportContainer/CraftPanel/OptionButton.add_item(recipes[count])
		var btn = $CraftIcon/SubViewportContainer/CraftPanel/CraftButton
		get_parent().enter_anvil_view()
		if not btn.pressed.is_connected(craft):
			btn.pressed.connect(craft)

func craft(_index: int = 0):
	var count = get_occupied_count()
	var result_name = recipes[count]
	for slot in slots:
		if slot["occupant"] != null:
			slot["occupant"].queue_free()
			slot["occupant"] = null
	$CraftIcon.hide()
	$CraftIcon/SubViewportContainer.hide()
	get_parent().exit_anvil_view()
	get_parent().spawn_item(_anvil.global_position + Vector3.UP * snap_height, result_name)  # 👈 Use _anvil
