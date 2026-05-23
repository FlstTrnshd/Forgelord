extends Node3D

@onready var interaction_manager: Node = $Interaction_Manager
@onready var item_spawner: Node = $Item_Spawner

const PlayerScene = preload("res://character_controller.tscn")
const CustomerCapsule = preload("res://customer_capsule.tscn")

var player = null

func _ready():
	player = PlayerScene.instantiate()
	add_child(player)
	player.global_position = Vector3.ZERO
	interaction_manager.initialize(player, player.get_camera())
	WorldClock.customer_ready.connect(_on_customer_ready)

func _on_customer_ready():
	var capsule = CustomerCapsule.instantiate()
	add_child(capsule)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			interaction_manager.click_ray()
	if event.is_action_pressed("ui_focus_next"):
		if interaction_manager.anvil_view:
			exit_anvil_view()

func enter_anvil_view():
	interaction_manager.enter_anvil_view($Anvil)

func exit_anvil_view():
	interaction_manager.exit_anvil_view()

func spawn_item(pos: Vector3, item_name: String, metal_type: ItemBase.MetalType):
	if item_spawner.WEAPONS.has(item_name):
		item_spawner.spawn_weapon(pos, item_name, metal_type)
	elif item_spawner.INGOT_SCENES.has(item_name):
		item_spawner.spawn_ingot(pos, item_name, metal_type)
	else:
		push_error("No scene found for: " + item_name)
