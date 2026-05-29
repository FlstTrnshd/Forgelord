extends CSGBox3D

var snap_height = 0.2

var slots = [
	{"offset": Vector3(-0.9, 0.0, 0.0), "occupant": null},
	{"offset": Vector3(0.0, 0.0, 0.0), "occupant": null},
	{"offset": Vector3(0.9, 0.0, 0.0), "occupant": null}
]

func can_receive(item) -> bool:
	return item is ItemBase and item.item_type == ItemBase.ItemType.CRAFTED_RESULT

func receive(item):
	var slot = get_free_slot()
	if slot == null:
		print("Shelf is full!")
		return
	var anvil = get_tree().get_first_node_in_group("Anvil")
	if anvil:
		anvil.clear_result()
	slot["occupant"] = item
	var down_offset = ItemBase.SHELF_OFFSETS.get(item.item, 0.3)
	item.global_position = global_position + Vector3.UP * snap_height + slot["offset"] + Vector3.DOWN * down_offset
	item.rotation_degrees.z = 180.0

func get_free_slot():
	for slot in slots:
		if slot["occupant"] == null:
			return slot
	return null
