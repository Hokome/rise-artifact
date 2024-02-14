class_name PlayerResources extends Node2D

signal death

@export var max_health := 50

@onready var health: int = max_health:
	set(value):
		health = value
		$box/health_text.text = str(value) + " HP"
		if health <= 0:
			death.emit()

@onready var power := 0:
	set(value):
		power = value
		$box/power_text.text = str(value) + " PW"

func damage(amount: int):
	health -= amount

func _ready():
	health = health
	power = power

func _on_game_battle_started(game):
	power += game.player_stats().power_per_round
func _on_game_round_ended(game: Game):
	power += game.player_stats().power_per_round

