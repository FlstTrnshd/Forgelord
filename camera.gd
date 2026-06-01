extends Camera3D

const SENSITIVITY = 0.003
@onready var raycast = $RayCast3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	var player = get_tree().get_first_node_in_group("player")
	if player.movable:
		if event is InputEventMouseMotion:
			get_parent().rotate_y(-event.relative.x * SENSITIVITY)
			rotate_x(-event.relative.y * SENSITIVITY)
			rotation.x = clamp(rotation.x, deg_to_rad(-80), deg_to_rad(80))
		if event.is_action_pressed("interact"):
			var collider = raycast.get_collider()
			if collider and collider.has_method("interact"):
				collider.interact(player.held, player.item_held)
	else:
		rotation = Vector3(-0.5, 0.0, 0.0)
