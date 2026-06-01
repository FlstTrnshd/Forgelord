extends StaticBody3D

func interact(a, b):
	var player = get_tree().get_first_node_in_group("player")
	var anvil_view = get_tree().get_nodes_in_group("Anvil")
	for i in range(len(anvil_view)):
		if anvil_view[i] is Marker3D:
			anvil_view = anvil_view[i]
	player.global_position = anvil_view.global_position
	player.movable = false
	player.anvil_view = true
