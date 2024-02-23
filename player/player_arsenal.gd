class_name PlayerArsenal extends Node2D

var leftover_health: int

func add_card_to_deck(card: Card):
	add_child(card)

func _on_game_battle_loaded(game: Game):
	var draw_pile := game.draw_pile()
	game.player_resources().health = leftover_health
	for card in get_children():
		draw_pile.add_card(game, card.duplicate())
