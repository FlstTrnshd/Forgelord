extends Node

signal tick_passed
signal day_ended(date: Dictionary)
signal week_ended(date: Dictionary)

const MONTHS = [
	"Urdumun", "Kaosmon", "Freyjmun", "Hademon",
	"Gaimun", "Zephmon", "Heimsmun", "Zaphmon",
	"Valhmun", "Noctmon"
]
const DAYS_PER_MONTH = 30
const DAYS_PER_WEEK = 7
const TICKS_PER_DAY = 100
const TICK_RATE = 0.1

signal customer_ready
var stall_occ = false
var day := 1
var month := 1
var year := 450
var current_tick := 0
var time_accumulator := 0.0

func _process(delta):
	time_accumulator += delta
	if time_accumulator >= TICK_RATE:
		time_accumulator -= TICK_RATE
		_on_tick()

func _on_tick():
	current_tick += 1
	tick_passed.emit()
	print("tick")
	customer_spawn()
	if current_tick >= TICKS_PER_DAY:
		current_tick = 0
		_on_day_end()

func customer_spawn():
	if stall_occ:
		return
	if randf() > 0.05:  # 5% chance per tick
		return
	stall_occ = true
	customer_ready.emit()

func _on_day_end():
	var date = get_date()
	day_ended.emit(date)
	if day % DAYS_PER_WEEK == 0:
		week_ended.emit(date)
	day += 1
	if day > DAYS_PER_MONTH:
		day = 1
		month += 1
	if month > MONTHS.size():
		month = 1
		year += 1

func get_date() -> Dictionary:
	return {
		"day": day,
		"month": MONTHS[month - 1],
		"year": year
	}

func advance_day():
	print("Day Ended")
	print(Kingdoms.relations)
	for contract in PlayerStatus.active_contracts:
		print(contract.weapon_type, " - ", contract.weapon_material, " - ", contract.price)
	Kingdoms.RelationTick()
	current_tick = TICKS_PER_DAY
