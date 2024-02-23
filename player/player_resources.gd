class_name PlayerResources extends Node2D

signal death
var stats: PlayerStats

var health: int:
	set(value):
		health = min(value, stats.max_health)
		$box/health_text.text = str(health) + " HP"
		if health <= 0:
			death.emit()

var power := 0:
	set(value):
		power = value
		$box/power_text.text = str(value) + " PW"

func damage(amount: int):
	health -= amount

func _on_game_battle_started(game: Game):
	health = game.player_arsenal().leftover_health
func _on_game_round_prepared(game: Game):
	power += game.player_stats().power_per_round

