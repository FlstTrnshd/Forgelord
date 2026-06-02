extends CharacterBody3D

const SPEED = 5.0
const GRAVITY = 9.8

signal holding_changed(is_holding)

@onready var camera = $Camera3D
var held = false:
	set(value):
		held = value
		emit_signal("holding_changed", value)
	
var item_held = null
var movable = true
var anvil_view = false:
	set(value):
		global_rotation = Vector3(0.0, 0.0, 0.0)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = (transform.basis * Vector3(input.x, 0, input.y)).normalized()
	
	if movable:
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tab") and movable != true:
		anvil_view = false
		movable = true
		print("Should Move Now")
	elif event.is_action_pressed("tab"):
		var weapon = get_tree().get_first_node_in_group("Weapon")
		weapon.get_mesh("Greatsword", "Blade")
