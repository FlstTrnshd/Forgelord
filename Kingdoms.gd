extends Node

const KINGDOMS = [
	"Hralgorn", "Drenwyn", "New Karthus", "Cirigras", 
	"Orikalth", "Veridia", "Khaeldros", "Dunsphyr", "Ferroskar", "Vjellor", 
	"Kriegsarm", "Zephyros", "Drosvarn"
]

const Lore_Rel = {
	["Cirigras", "Hralgorn" ]: 90,
	["Cirigras", "Drenwyn"]: 20,
	["Drenwyn", "Karthus"]: 70,
	["Drosvarn", "Zephyros"]: 40,
	["Khaeldros", "Veridia"]: 30,
	["Hralgorn", "Veridia"]: 60,
}

var relations = {}

func _ready():
	for i in KINGDOMS.size():
		for j in range(i + 1, KINGDOMS.size()):
			var pair = [KINGDOMS[i], KINGDOMS[i+1]]
			relations[pair] = 50.0
	for pair in Lore_Rel:
		relations[pair] = Lore_Rel[pair]

func calc_drift(rel):
	var targ_rel = 50
	var diff = rel - targ_rel
	var drift = diff / 30
	return drift

func RelationTick():
	for pair in relations:
		relations[pair] -= calc_drift(relations[pair])
		print(relations[pair])
