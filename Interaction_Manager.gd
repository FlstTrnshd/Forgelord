extends Node

const LERP_SPEED = 10.0
const CARRY_DISTANCE = 1.5

var cam: Camera3D = null
var player = null
var hovered_object = null
var held_item = null
var anvil_view := false
var original_pos := Vector3.ZERO
var original_rot := Vector3.ZERO
var anvil_view_pos := Vector3.ZERO

func initialize(p, camera: Camera3D):
	player = p
	cam = camera

func _process(delta):
	if cam == null:
		return
	if anvil_view:
		_lerp_to_anvil_view(delta)
	if held_item != null:
		_carry_item()
	_hover_ray()

func _carry_item():
	var ray_origin = cam.project_ray_origin(get_viewport().get_visible_rect().size / 2)
	held_item.global_position = ray_origin + cam.project_ray_normal(get_viewport().get_visible_rect().size / 2) * CARRY_DISTANCE

func _lerp_to_anvil_view(delta):
	cam.global_position = cam.global_position.lerp(anvil_view_pos, LERP_SPEED * delta)
	var target_rotation = Quaternion(Vector3.RIGHT, deg_to_rad(-90)) * Quaternion(Vector3.UP, deg_to_rad(0))
	cam.global_transform.basis = Basis(
		cam.global_transform.basis.get_rotation_quaternion().slerp(target_rotation, LERP_SPEED * delta)
	)

func _get_ray_result():
	var space_state = get_viewport().get_world_3d().direct_space_state
	var screen_center = get_viewport().get_visible_rect().size / 2
	var ray_origin = cam.project_ray_origin(screen_center)
	var ray_end = ray_origin + cam.project_ray_normal(screen_center) * 1000.0
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	if held_item != null:
		query.exclude = [held_item.get_rid()]
	return space_state.intersect_ray(query)

func _hover_ray():
	if held_item != null:
		return
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

func click_ray():
	if anvil_view:
		return
	var result = _get_ray_result()
	if not result:
		return
	var node = result.collider
	while node != null:
		if held_item == null:
			if node.has_method("can_carry") and node.can_carry():
				held_item = node
				return
			if node.has_method("interact"):
				node.interact()
				return
		else:
			if node.has_method("can_receive") and node.can_receive(held_item):
				node.receive(held_item)
				held_item = null
				return
		node = node.get_parent()

func enter_anvil_view(anvil: Node3D):
	anvil_view = true
	original_pos = cam.global_position
	original_rot = cam.rotation
	anvil_view_pos = anvil.global_position + Vector3(0, 3, 0)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
