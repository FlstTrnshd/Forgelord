class_name Interactable
extends StaticBody3D

@export var type: String
var placed = true

func _ready():
	collision_layer = 2
	collision_mask = 0

func interact(held, item_held = null):
	if held == false:
		if placed == true:
			var parent = get_parent()
			if parent is shelf_slot:
				parent.removed_slot()
		var player = get_tree().get_first_node_in_group("player")
		var hand = player.get_node("Camera3D/Hand_Position")
		reparent(hand)
		global_position = hand.global_position
		rotation = Vector3(0, 0, 0)
		player.held = true
		player.item_held = self
		placed = false
		print(get_parent())
