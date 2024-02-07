class_name CardPile extends Node

var cards: Array[Card]

func _ready():
	cards = []
	for card in get_children():
		cards.append(card)

func draw_card(game: Game):
	if cards.is_empty():
		return
	
	var card = cards[0]
	
	remove_card(card)
	game.hand().add_card(card)

func remove_card(card: Card):
	cards.erase(card)

func add_card(card: Card):
	cards.append(card)
	card.reparent(self)
	card.current_pile = self

func discard(game: Game, card: Card):
	cards.erase(card)
	game.discard_pile().add_card(card)

func try_play(game: Game, card_index: int):
	if cards.size() <= card_index:
		return
	
	var card = cards[card_index]

	if !card.can_play(game):
		return
		
	await card.play(game)
