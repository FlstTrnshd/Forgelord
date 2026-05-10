extends StaticBody3D

var iron_shelf = null
var slots = null

func _ready():
	iron_shelf = get_tree().get_first_node_in_group("iron_shelf")
	slots = iron_shelf.slots

func interact():
	print("interacted")
	for slot in slots:
		if slot["occupant"] == null:
			var pos = iron_shelf.global_position + Vector3.UP * iron_shelf.snap_height + slot["offset"]
			slot["occupant"] = "Iron_Ingot"
			get_parent().spawn_item(pos, "Iron_Ingot", Ingot.MetalType.IRON)
			break
