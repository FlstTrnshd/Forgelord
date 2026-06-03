extends Bench
class_name Workbench

func auto_craft():
	for child in get_children():
		if child is Marker3D:
			for i in child.get_children():
				if i is StaticBody3D:
					for item in i.get_children():
						if item is Weapon:
							item.get_mesh(item.weapon_type, "Guard")
							item.get_mesh(item.weapon_type, "Hilt")
							item.get_mesh(item.weapon_type, "Pommel")
							print("shi")
