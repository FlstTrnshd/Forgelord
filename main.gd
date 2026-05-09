extends Node3D

var hovered_object = null
var anvil_view := false
var original_pos := Vector3.ZERO
var original_rot := Vector3.ZERO
var anvil_view_pos := Vector3.ZERO

const LERP_SPEED = 10.0
const ITEM_SCENES = {
	"Spear_Head": preload("res://Spear_Head.tscn"),
	"ShortSword_Blade": preload("res://Short_Sword.tscn"),
	"GreatSword_Blade": preload("res://Great_Sword.tscn"),
}
const INGOT_TYPES = {
	"Iron_Ingot": preload("res://ingot.tscn")
}
const PlayerScene = preload("res://character_controller.tscn")  # 👈 const not var
var player = null  # 👈 Holds the instance
var cam: Camera3D = null

func _ready():
	player = PlayerScene.instantiate()  # 👈 Store the instance
	add_child(player)                   # 👈 Add before accessing anything on it
	player.global_position = Vector3(0, 0, 0)  # 👈 Set spawn point
	cam = player.get_camera()
	original_pos = cam.global_position
	original_rot = cam.rotation

func spawn_item(pos: Vector3, item_name: String):
	if ITEM_SCENES.has(item_name):
		var item = ITEM_SCENES[item_name].instantiate()
		$Anvil.add_child(item)
		item.global_position = pos
	elif INGOT_TYPES.has(item_name):
		var item = INGOT_TYPES[item_name].instantiate()
		$StaticBody3D/Wall_Main/CSGBox3D.add_child(item)
		item.global_position = pos
	else:
		push_error("No scene found for: " + item_name)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_click_ray()
	if event.is_action_pressed("ui_focus_next"):
		if anvil_view:
			exit_anvil_view()

func _process(delta):
	if anvil_view:
		cam.global_position = cam.global_position.lerp(anvil_view_pos, LERP_SPEED * delta)
		var target_rotation = Quaternion(Vector3.RIGHT, deg_to_rad(-90)) * Quaternion(Vector3.UP, deg_to_rad(0))
		cam.global_transform.basis = Basis(cam.global_transform.basis.get_rotation_quaternion().slerp(target_rotation, LERP_SPEED * delta))
	_hover_ray()

func _get_ray_result():
	var space_state = get_world_3d().direct_space_state
	var screen_center = get_viewport().get_visible_rect().size / 2
	var ray_origin = cam.project_ray_origin(screen_center)
	var ray_end = ray_origin + cam.project_ray_normal(screen_center) * 1000.0
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	return space_state.intersect_ray(query)

func _hover_ray():
	var result = _get_ray_result()
	if result:
		var collider = result.collider.get_parent()
		if collider.has_method("highlight"):
			if hovered_object != collider:
				if hovered_object:
					hovered_object.unhighlight()
				hovered_object = collider
				hovered_object.highlight()
	elif hovered_object:
		hovered_object.unhighlight()
		hovered_object = null

func _click_ray():
	if anvil_view:
		return
	var result = _get_ray_result()
	if result:
		var node = result.collider
		while node != null:
			if node.has_method("interact"):
				node.interact()
				break
			node = node.get_parent()

func enter_anvil_view():
	anvil_view = true
	original_pos = cam.global_position
	original_rot = cam.rotation
	anvil_view_pos = $Anvil.global_position + Vector3(0, 3, 0)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	player.lock()

func exit_anvil_view():
	anvil_view = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam.global_position = original_pos
	cam.rotation = original_rot
	player.unlock()
	$Anvil.get_node("CraftIcon/SubViewportContainer").hide()
