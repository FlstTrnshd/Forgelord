extends Bench

func auto_craft():
	for child in get_children():
		if child is Marker3D:
			for item in child.get_children():
				print("less shi")
				if item is Weapon:
					item.get_mesh(item.weapon_type, "Guard")
					item.get_mesh(item.weapon_type, "Hilt")
					item.get_mesh(item.weapon_type, "Pommel")
					print("shi")
