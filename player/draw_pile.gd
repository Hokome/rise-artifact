extends CardPile

func draw_card(game: Game):
	if cards.is_empty():
		game.discard_pile().shuffle_into(game, self)
	
	var card = cards[0]
	
	remove_card(card)
	game.hand().add_card(game, card)
