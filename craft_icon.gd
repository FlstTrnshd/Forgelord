extends StaticBody3D

func interact():
	var anvil = get_tree().get_first_node_in_group("Anvil")
	anvil.hammer_clicked()
	print("Hammer")
	
func highlight():
	pass

func unhighlight():
	pass
