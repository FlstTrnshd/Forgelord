extends CSGBox3D

var snap_height = 0.2

var slots = [
	{"offset": Vector3(-0.9, 0.0, 0.0), "occupant": null},
	{"offset": Vector3(0.0, 0.0, 0.0), "occupant": null},
	{"offset": Vector3(0.9, 0.0, 0.0), "occupant": null}
]

func get_free_slot():
	for slot in slots:
		if slot["occupant"] == null:
			return slot
	return null
