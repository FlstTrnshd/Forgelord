class_name Interactable
extends StaticBody3D

@export var type: String

func _ready():
	collision_layer = 2
	collision_mask = 0

func interact(held, item_held = null):
	if held == false:
		var player = get_tree().get_first_node_in_group("player")
		var hand = player.get_node("Camera3D/Hand_Position")
		reparent(hand)
		global_position = hand.global_position
		rotation = Vector3(0, 0, 0)
		player.held = true
		player.item_held = self
