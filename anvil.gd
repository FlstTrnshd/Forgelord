extends Bench

const WEAPON_INGOT_COUNT = {1: "Dagger", 2: "Shortsword", 3: "Greatsword"}
@onready var WeaponScne = load("res://Weapon.tscn")
@onready var player = get_tree().get_first_node_in_group("player")

var forge_confirmed = true

var PH_Instance = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm") and forge_confirmed == false:
		print("Trust")
		confirm_forging()
	elif event.is_action_pressed("tab") and forge_confirmed == false:
		cancel_forging()

func begin_forging():
	if assigned_slots in WEAPON_INGOT_COUNT:
		for child in get_children():
			if child is Marker3D:
				for slot in child.get_children():
					if slot is shelf_slot:
						for ingot in slot.get_children():
							if ingot is Ingot:
								ingot.hide()
								ingot.collision_layer = 0
		var weapon = WEAPON_INGOT_COUNT[assigned_slots]
		var instance = WeaponScne.instantiate()
		$Marker3D2.add_child(instance)
		instance.rotation_degrees = Vector3(90.0, 0.0, 90.0)
		instance.get_mesh(weapon, "Blade")
		PH_Instance = instance
		forge_confirmed = false

func confirm_forging():
	for child in get_children():
		if child is Marker3D:
			for slot in child.get_children():
				if slot is shelf_slot:
					for ingot in slot.get_children():
						if ingot is Ingot:
							ingot.queue_free()
							forge_confirmed = true
							assigned_slots = 0
							player.free_movement()
					slot.occupied = false

func cancel_forging():
	for child in get_children():
		if child is Marker3D:
			for slot in child.get_children():
				if slot is shelf_slot:
					for ingot in slot.get_children():
						if ingot is Ingot:
							print("Glup")
							ingot.show()
							ingot.collision_layer = 2
							forge_confirmed = true
							if PH_Instance != null:
								PH_Instance.queue_free()
