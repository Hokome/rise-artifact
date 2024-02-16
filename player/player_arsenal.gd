class_name PlayerArsenal extends Node2D

@export var deck: Array[PackedScene]
var leftover_health: int

func _on_game_battle_loaded(game: Game):
	var draw_pile := game.draw_pile()
	game.player_resources().health = leftover_health
	for card in deck:
		draw_pile.add_card(game, card.instantiate())
