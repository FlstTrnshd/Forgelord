class_name CustomerCapsule
extends CharacterBody3D

const WEAPON_TYPES = ["Sword", "Axe", "Dagger", "Spear"]
const WEAPON_MATERIALS = ["Iron"]

var contract: Contracts
var at_stall := false

func _ready():
	at_stall = true
	contract = _generate_contract()
	
func _generate_contract() -> Contracts:
	var c = Contracts.new()
	c.weapon_type = WEAPON_TYPES[randi() % WEAPON_TYPES.size()]
	c.weapon_material = WEAPON_MATERIALS[randi() % WEAPON_MATERIALS.size()]
	c.price = randi_range(20, 100)
	return c

func interact():
	if not at_stall:
		print("Test")
		return
	# For now, just print the offer
	print("Customer offers: ", contract.weapon_type, " in ", contract.weapon_material, " for ", contract.price, "g")
	# We'll hook up UI acceptance here later
	_accept_contract()

func _accept_contract():
	PlayerStatus.active_contracts.append(contract)
	WorldClock.stall_occ = false
	_leave()

func _leave():
	var tween = create_tween()
	# Tween back offscreen, then delete self
	tween.tween_property(self, "position", position + Vector3(-10, 0, 0), 2.0)
	tween.tween_callback(queue_free)
