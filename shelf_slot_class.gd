class_name shelf_slot
extends StaticBody3D

var marker
var occupied = false

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
		if item.type == "ingot" or "Weapon" and occupied == false:
			item.reparent(self)
			var parent = self
			while not parent is Bench or parent == get_tree().root:
				parent = parent.get_parent()
			item.global_position = marker.global_position
			item.rotation = Vector3(0.0, 0.0, 0.0)
			if item.type == "Weapon" and parent is Workbench:
				item.rotation_degrees = Vector3(90.0, 90.0, 0.0)
			var player = get_tree().get_first_node_in_group("player")
			player.held = false
			player.item_held = null
			item.placed = true
			occupied = true
			if parent is Bench:
				parent.assigned_slots += 1
				print(parent.assigned_slots)
				print(item.get_parent())
			if parent.has_method("auto_craft"):
				parent.auto_craft()

func removed_slot():
	print("Uhhh")
	var parent = self
	while not parent is Bench or parent == get_tree().root:
		parent = parent.get_parent()
	if parent is Bench:
		parent.assigned_slots -= 1
		print(parent.assigned_slots)
		occupied = false
		
