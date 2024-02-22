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
	game.hand().add_card(game, card)

func discard(game: Game, card: Card):
	remove_card(card)
	game.discard_pile().add_card(game, card)

func shuffle():
	if cards.is_empty():
		return
	cards.shuffle()

func shuffle_into(game: Game, pile: CardPile):
	for card in cards:
		pile.add_card(game, card)
		remove_card(card)
	pile.shuffle()

func remove_card(card: Card):
	cards.erase(card)

func add_card(_game: Game, card: Card):
	cards.append(card)
	if card.get_parent() != null:
		card.reparent(self)
	else:
		add_child(card)
	card.current_pile = self

func remove_all():
	for card_id in cards.size():
		cards[0].queue_free()
		remove_card(cards[0])
	cards.clear()
