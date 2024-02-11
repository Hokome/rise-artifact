class_name CardPile extends Node

@export var max_size: int = 0
@export var play_on_click := false

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

func shuffle_into(game: Game, pile: CardPile):
	for card in cards:
		pile.add_card(game, card)
		remove_card(card)
	pile.cards.shuffle()

func remove_card(card: Card):
	if play_on_click:
		card.clicked.disconnect(on_card_click)
	cards.erase(card)

func add_card(game: Game, card: Card):
	if max_size != 0 and cards.size() == max_size:
		discard(game, cards[max_size - 1])
	
	if play_on_click:
		card.clicked.connect(on_card_click)
	
	cards.append(card)
	card.reparent(self)
	card.current_pile = self


func try_play(game: Game, card: Card):
	if !card.can_play(game):
		return
	
	await card.play(game)

func on_card_click(card: Card):
	try_play.call_deferred($"..", card)
