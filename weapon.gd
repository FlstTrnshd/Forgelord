extends Interactable
class_name Weapon

const WEAPON_MESHES = ["Greatsword"]
const MESH_PATH = "res://Weapon_Meshes/"

@export var swing_speed = 0.0
@export var swing_damage = 0.0
@export var stab_speed = 0.0
@export var stab_damage = 0.0
@export var reach = 0.0
@export var ingot_used = 0.0
@export var tier = 0.0
@export var weapon_type = ""

func get_mesh(weapon: String, segment: String):
	if weapon not in WEAPON_MESHES:
		print("Kill Yourself (Sigma)")
	var path = MESH_PATH + weapon + "/Base_" + weapon + "_" + segment + ".fbx"
	if not ResourceLoader.exists(path):
		print("Kill Yourself (Cuck)" + path)
	else:
		var instance = load(path).instantiate()
		instance.scale = Vector3(0.5, 0.5, 0.5)
		add_child(instance)
