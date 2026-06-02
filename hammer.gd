extends StaticBody3D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var anvil = get_tree().get_nodes_in_group("Anvil")
var anvil_view = null

func interact(a, b):
	for i in range(len(anvil)):
		if anvil[i] is Marker3D:
			anvil_view = anvil[i]
	player.global_position = anvil_view.global_position
	player.movable = false
	player.anvil_view = true
	anvil[0].begin_forging()
