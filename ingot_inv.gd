extends StaticBody3D

var iron_shelf = null
var slots = null

func _ready():
	iron_shelf = get_tree().get_first_node_in_group("iron_shelf")
	slots = iron_shelf.slots

func interact():
	if PlayerStatus.player_ingots["Iron"] <= 0:
		print("No iron ingots left!")
		return
	for slot in slots:
		if slot["occupant"] == null:
			var pos = iron_shelf.global_position + Vector3.UP * iron_shelf.snap_height + slot["offset"]
			slot["occupant"] = "Iron_Ingot"
			PlayerStatus.player_ingots["Iron"] -= 1
			get_parent().spawn_item(pos, "Iron_Ingot", Ingot.MetalType.IRON)
			print(PlayerStatus.player_ingots["Iron"])
			break
