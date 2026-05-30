class_name shelf_slot
extends StaticBody3D

var marker

func _ready():
	marker = get_parent()
	collision_layer = 0
	var player = get_tree().get_first_node_in_group("player")
	player.holding_changed.connect(_holding_changed)

func _holding_changed(is_holding):
	collision_layer = 2 if is_holding else 0

func interact(held, item):
	print("Yo")
	if held == true:
		if item.type == "ingot":
			item.reparent(marker)
			item.global_position = marker.global_position
			item.rotation = Vector3(0, 0, 0)
			var player = get_tree().get_first_node_in_group("player")
			player.held = false
			player.item_held = null
	else:
		print("Nothing Held")
