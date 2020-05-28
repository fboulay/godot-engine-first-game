extends Node

const LABEL = "label"
const MOB_SPAWN_RATE = "mob_spawn_rate"
const MOB_SPEED_MIN = "mob_speed_min"
const MOB_SPEED_MAX = "mob_speed_max"

enum Difficulty { EASY, NORMAL, HARD, HARDEST}

export var _LEVELS = {
	Difficulty.EASY: {
		LABEL: "Easy",
		MOB_SPAWN_RATE: 2.0,
		MOB_SPEED_MIN : 50,
		MOB_SPEED_MAX : 150
	},
	Difficulty.NORMAL :{
		LABEL: "Normal",
		MOB_SPAWN_RATE: 1.0,
		MOB_SPEED_MIN : 100,
		MOB_SPEED_MAX : 200
	},
	Difficulty.HARD :{
		LABEL: "Hard",
		MOB_SPAWN_RATE: 0.5,
		MOB_SPEED_MIN : 150,
		MOB_SPEED_MAX : 250
	},
	Difficulty.HARDEST :{
		LABEL: "Hardest",
		MOB_SPAWN_RATE: 0.3,
		MOB_SPEED_MIN : 100,
		MOB_SPEED_MAX : 300
	},
}

func get_base_difficulty() -> int:
	return Difficulty.EASY

func get_mob_spawn_rate(difficulty: int) -> float:
	return _LEVELS[difficulty][MOB_SPAWN_RATE]

func get_mob_min_speed(difficulty: int) -> float:
	return _LEVELS[difficulty][MOB_SPEED_MIN]

func get_mob_max_speed(difficulty: int) -> float:
	return _LEVELS[difficulty][MOB_SPEED_MAX]

func get_label(difficulty: int) -> float:
	return _LEVELS[difficulty][LABEL]

func next_difficulty(current_difficulty: int) -> int:
	return (current_difficulty + 1) % _LEVELS.size()
