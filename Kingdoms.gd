extends Node

const KINGDOMS = [
	"Hralgorn", "Drenwyn", "New Karthus", "Cirigras", 
	"Orikalth", "Veridia", "Khaeldros", "Dunsphyr", "Ferroskar", "Vjellor", 
	"Kriegsarm", "Zephyros", "Drosvarn"
]

const KINGDOM_STATS = {
	"Hralgorn": {"military": 6000, "prosperity": 4000},
	"Drenwyn": {"military": 5000, "prosperity": 5000},
	"New Karthus": {"military": 8000, "prosperity": 2000},
	"Cirigras": {"military": 4000, "prosperity": 6000},
	"Orikalth": {"military": 3000, "prosperity": 7000},
	"Veridia": {"military": 5000, "prosperity": 5000},
	"Khaeldros": {"military": 4000, "prosperity": 6000},
	"Dunsphyr": {"military": 1000, "prosperity": 9000},
	"Drosvarn": {"military": 8000, "prosperity": 2000},
	"Zephyros": {"military": 6000, "prosperity": 4000},
	"Ferroskar": {"military": 7000, "prosperity": 3000},
	"Vjellor": {"military": 9000, "prosperity": 1000},
	"Kriegsarm": {"military": 7000, "prosperity": 3000},
}

const KINGDOM_DOCTRINE = {
	"Hralgorn": "Shield",
	"Drenwyn": "Isolationist",
	"New Karthus": "Imperium",
	"Cirigras": "Shield",
	"Orikalth": "Isolationist",
	"Veridia": "Shield",
	"Khaeldros": "Isolationist",
	"Dunsphyr": "Imperium",
	"Ferroskar": "Imperium",
	"Vjellor": "Imperium",
	"Kriegsarm": "Isolationist",
	"Zephyros": "Isolationist",
	"Drosvarn": "Isolationist",
}

const BORDERS = {
	"Kriegsarm": ["Hralgorn"],
	"Hralgorn": ["Kriegsarm", "Drenwyn", "New Karthus", "Cirigras", "Orikalth"],
	"Drenwyn": ["Hralgorn", "New Karthus", "Cirigras"],
	"New Karthus": ["Hralgorn", "Drenwyn", "Cirigras"],
	"Cirigras": ["Hralgorn", "Drenwyn", "New Karthus", "Orikalth"],
	"Orikalth": ["Hralgorn", "Cirigras", "Veridia"],
	"Veridia": ["Orikalth", "Khaeldros", "Dunsphyr"],
	"Khaeldros": ["Veridia", "Dunsphyr"],
	"Dunsphyr": ["Veridia", "Khaeldros"],
	"Ferroskar": ["Zephyros"],
	"Zephyros": ["Ferroskar", "Drosvarn"],
	"Drosvarn": ["Ferroskar", "Zephyros"],
	"Vjellor": [],
}

const Lore_Rel = {
	"Cirigras_Hralgorn": 90,
	"Cirigras_Drenwyn": 20,
	"Drenwyn_New Karthus": 70,
	"Drosvarn_Zephyros": 40,
	"Khaeldros_Veridia": 30,
	"Hralgorn_Veridia": 60,
}

const ALLIANCE_FLOORS = {
	"Hralgorn_Veridia": 50,
	"Hralgorn_Cirigras": 50,
	"Cirigras_Orikalth": 50,
	"Orikalth_Veridia": 50,
}

const ISOLATIONIST_CEILING = 70.0
const STRENGTH_THRESHOLD = 1.2
const ALLY_THRESHOLD = 70.0
const ENEMY_THRESHOLD = 30.0
const NEIGHBOUR_MULTIPLIER = 1.5
const DISTANT_MULTIPLIER = 0.4

var relations = {}
var current_stats = {}

func _ready():
	for kingdom in KINGDOM_STATS:
		current_stats[kingdom] = {
			"military": KINGDOM_STATS[kingdom]["military"],
			"prosperity": KINGDOM_STATS[kingdom]["prosperity"]
		}
	for i in KINGDOMS.size():
		for j in range(i + 1, KINGDOMS.size()):
			var key = get_pair_key(KINGDOMS[i], KINGDOMS[j])
			relations[key] = 50.0
	for pair in Lore_Rel:
		relations[pair] = Lore_Rel[pair]

# --- Helpers ---

func get_pair_key(a, b):
	var sorted = [a, b]
	sorted.sort()
	return sorted[0] + "_" + sorted[1]

func get_relation(a, b):
	return relations.get(get_pair_key(a, b), 50.0)

func are_neighbours(a, b):
	return b in BORDERS[a]

func distance_multiplier(a, b):
	if are_neighbours(a, b):
		return NEIGHBOUR_MULTIPLIER
	return DISTANT_MULTIPLIER

# --- Stat Comparisons ---

func is_stronger(a, b):
	return current_stats[a]["military"] >= current_stats[b]["military"] * STRENGTH_THRESHOLD

func is_richer(a, b):
	return current_stats[a]["prosperity"] >= current_stats[b]["prosperity"] * STRENGTH_THRESHOLD

func is_ally(a, b):
	return get_relation(a, b) >= ALLY_THRESHOLD

func is_enemy(a, b):
	return get_relation(a, b) <= ENEMY_THRESHOLD

# --- Drift Factors ---

func base_drift(rel):
	var diff = 50.0 - rel
	return diff / 30.0

func doctrine_factor(a, b):
	var doctrine_a = KINGDOM_DOCTRINE[a]
	var doctrine_b = KINGDOM_DOCTRINE[b]
	
	if not are_neighbours(a, b):
		return 0.0
	
	var factor = 0.0
	
	# A's doctrine effect on B
	if doctrine_a == "Imperium":
		if is_stronger(a, b):
			factor -= 0.6  # bullies weaker neighbours
	elif doctrine_a == "Shield":
		if is_stronger(a, b):
			factor += 0.4  # protects weaker neighbours
	# Isolationist has no modifier here
	
	# B's doctrine effect on A
	if doctrine_b == "Imperium":
		if is_stronger(b, a):
			factor -= 0.6
	elif doctrine_b == "Shield":
		if is_stronger(b, a):
			factor += 0.4
	
	return factor

func ally_chain_factor(a, b):
	var factor = 0.0
	for kingdom in KINGDOMS:
		if kingdom == a or kingdom == b:
			continue
		if is_ally(a, kingdom):
			if is_ally(kingdom, b):
				factor += 0.4
			elif is_enemy(kingdom, b):
				factor -= 0.4
		elif is_enemy(a, kingdom):
			if is_enemy(kingdom, b):
				factor += 0.3
			elif is_ally(kingdom, b):
				factor -= 0.3
	return factor

func calc_total_drift(a, b):
	var rel = get_relation(a, b)
	var drift = 0.0
	drift += base_drift(rel)
	drift += doctrine_factor(a, b)
	drift += ally_chain_factor(a, b)
	var multiplier = distance_multiplier(a, b)
	return drift * multiplier

# --- Prosperity Tick ---

func prosperity_tick():
	for kingdom in current_stats:
		var base = KINGDOM_STATS[kingdom]["prosperity"]
		var current = current_stats[kingdom]["prosperity"]
		if current < base:
			var diff = base - current
			current_stats[kingdom]["prosperity"] += max(1, diff / 20)

# --- Main Tick ---

func RelationTick():
	prosperity_tick()
	for pair in relations:
		var a = ""
		var b = ""
		for kingdom in KINGDOMS:
			if pair.begins_with(kingdom + "_"):
				a = kingdom
				b = pair.substr(kingdom.length() + 1)
				break
			elif pair.ends_with("_" + kingdom):
				b = kingdom
				a = pair.substr(0, pair.length() - kingdom.length() - 1)
				break
		
		if a == "" or b == "":
			continue
		
		var drift = calc_total_drift(a, b)
		relations[pair] = relations[pair] + drift
		
		# Alliance floors
		if pair in ALLIANCE_FLOORS:
			relations[pair] = max(relations[pair], ALLIANCE_FLOORS[pair])
		
		# Isolationist ceiling
		var doc_a = KINGDOM_DOCTRINE[a]
		var doc_b = KINGDOM_DOCTRINE[b]
		if doc_a == "Isolationist" or doc_b == "Isolationist":
			relations[pair] = min(relations[pair], ISOLATIONIST_CEILING)
		
		relations[pair] = clamp(relations[pair], 0.0, 100.0)

# --- Random Events ---

func random_relation_event(a, b, amount):
	var key = get_pair_key(a, b)
	relations[key] = clamp(relations[key] + amount, 0.0, 100.0)
	if key in ALLIANCE_FLOORS:
		relations[key] = max(relations[key], ALLIANCE_FLOORS[key])
	var doc_a = KINGDOM_DOCTRINE[a]
	var doc_b = KINGDOM_DOCTRINE[b]
	if doc_a == "Isolationist" or doc_b == "Isolationist":
		relations[key] = min(relations[key], ISOLATIONIST_CEILING)
