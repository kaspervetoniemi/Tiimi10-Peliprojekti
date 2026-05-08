extends Node

signal level_started(level_number: int, is_boss_level: bool)
signal game_completed

@export var max_level: int = 15

var current_level: int = 1


var levels: Dictionary = {
	1: {
		"enemy_count": 14,
		"enemy_speed": 32.0,
		"background_stage": 1,
		"boss": false,
		"boss_health": 0,
		"shoot_interval_min": 2.2,
		"shoot_interval_max": 3.6,
		"bullet_speed": 180.0,
		"max_shots_per_wave": 1
	},
	2: {
		"enemy_count": 16,
		"enemy_speed": 36.0,
		"background_stage": 1,
		"boss": false,
		"boss_health": 0,
		"shoot_interval_min": 2.0,
		"shoot_interval_max": 3.3,
		"bullet_speed": 190.0,
		"max_shots_per_wave": 1
	},
	3: {
		"enemy_count": 18,
		"enemy_speed": 40.0,
		"background_stage": 1,
		"boss": false,
		"boss_health": 0,
		"shoot_interval_min": 1.8,
		"shoot_interval_max": 3.0,
		"bullet_speed": 200.0,
		"max_shots_per_wave": 2
	},
	4: {
		"enemy_count": 21,
		"enemy_speed": 44.0,
		"background_stage": 1,
		"boss": false,
		"boss_health": 0,
		"shoot_interval_min": 1.6,
		"shoot_interval_max": 2.7,
		"bullet_speed": 210.0,
		"max_shots_per_wave": 2
	},
	5: {
		"enemy_count": 0,
		"enemy_speed": 50.0,
		"background_stage": 1,
		"boss": true,
		"boss_health": 250,
		"shoot_interval_min": 1.2,
		"shoot_interval_max": 2.0,
		"bullet_speed": 230.0,
		"max_shots_per_wave": 3
	},

	6: {
		"enemy_count": 24,
		"enemy_speed": 50.0,
		"background_stage": 2,
		"boss": false,
		"boss_health": 0,
		"shoot_interval_min": 1.5,
		"shoot_interval_max": 2.5,
		"bullet_speed": 225.0,
		"max_shots_per_wave": 2
	},
	7: {
		"enemy_count": 26,
		"enemy_speed": 56.0,
		"background_stage": 2,
		"boss": false,
		"boss_health": 0,
		"shoot_interval_min": 1.35,
		"shoot_interval_max": 2.3,
		"bullet_speed": 240.0,
		"max_shots_per_wave": 3
	},
	8: {
		"enemy_count": 28,
		"enemy_speed": 62.0,
		"background_stage": 2,
		"boss": false,
		"boss_health": 0,
		"shoot_interval_min": 1.2,
		"shoot_interval_max": 2.1,
		"bullet_speed": 255.0,
		"max_shots_per_wave": 3
	},
	9: {
		"enemy_count": 30,
		"enemy_speed": 68.0,
		"background_stage": 2,
		"boss": false,
		"boss_health": 0,
		"shoot_interval_min": 1.05,
		"shoot_interval_max": 1.9,
		"bullet_speed": 270.0,
		"max_shots_per_wave": 4
	},
	10: {
		"enemy_count": 0,
		"enemy_speed": 74.0,
		"background_stage": 2,
		"boss": true,
		"boss_health": 450,
		"shoot_interval_min": 0.85,
		"shoot_interval_max": 1.55,
		"bullet_speed": 290.0,
		"max_shots_per_wave": 5
	},

	11: {
		"enemy_count": 32,
		"enemy_speed": 76.0,
		"background_stage": 3,
		"boss": false,
		"boss_health": 0,
		"shoot_interval_min": 1.0,
		"shoot_interval_max": 1.75,
		"bullet_speed": 285.0,
		"max_shots_per_wave": 4
	},
	12: {
		"enemy_count": 34,
		"enemy_speed": 82.0,
		"background_stage": 3,
		"boss": false,
		"boss_health": 0,
		"shoot_interval_min": 0.9,
		"shoot_interval_max": 1.6,
		"bullet_speed": 300.0,
		"max_shots_per_wave": 5
	},
	13: {
		"enemy_count": 36,
		"enemy_speed": 88.0,
		"background_stage": 3,
		"boss": false,
		"boss_health": 0,
		"shoot_interval_min": 0.8,
		"shoot_interval_max": 1.45,
		"bullet_speed": 315.0,
		"max_shots_per_wave": 5
	},
	14: {
		"enemy_count": 38,
		"enemy_speed": 96.0,
		"background_stage": 3,
		"boss": false,
		"boss_health": 0,
		"shoot_interval_min": 0.7,
		"shoot_interval_max": 1.3,
		"bullet_speed": 330.0,
		"max_shots_per_wave": 6
	},
	15: {
		"enemy_count": 0,
		"enemy_speed": 105.0,
		"background_stage": 3,
		"boss": true,
		"boss_health": 750,
		"shoot_interval_min": 0.55,
		"shoot_interval_max": 1.1,
		"bullet_speed": 360.0,
		"max_shots_per_wave": 7
	}
}


func start_game() -> void:
	current_level = 15
	level_started.emit(current_level, is_boss_level())


func next_level() -> void:
	current_level += 1

	if current_level > max_level:
		game_completed.emit()
		return

	level_started.emit(current_level, is_boss_level())


func get_current_level_data() -> Dictionary:
	return levels.get(current_level, levels[1])


func is_boss_level() -> bool:
	return bool(get_current_level_data()["boss"])


func get_enemy_count() -> int:
	return int(get_current_level_data()["enemy_count"])


func get_alien_speed() -> float:
	return float(get_current_level_data()["enemy_speed"])


func get_background_stage() -> int:
	return int(get_current_level_data()["background_stage"])


func get_boss_health() -> int:
	return int(get_current_level_data()["boss_health"])


func get_shoot_interval_min() -> float:
	return float(get_current_level_data()["shoot_interval_min"])


func get_shoot_interval_max() -> float:
	return float(get_current_level_data()["shoot_interval_max"])


func get_bullet_speed() -> float:
	return float(get_current_level_data()["bullet_speed"])


func get_max_shots_per_wave() -> int:
	return int(get_current_level_data()["max_shots_per_wave"])


func get_level_text() -> String:
	if is_boss_level():
		return "LEVEL " + str(current_level) + " - BOSS"

	return "LEVEL " + str(current_level)
