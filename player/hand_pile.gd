extends CardPile

@export var max_size: int = 6
@export var card_controller_scene: PackedScene

func add_card(game: Game, card: Card):
	if max_size != 0 and cards.size() == max_size:
		discard(game, cards[0])
	
	var card_controller = card_controller_scene.instantiate()
	add_child(card_controller)
	card_controller.card = card
	card.controller = card_controller
	
	card_controller.clicked.connect(on_card_click)
	cards.append(card)
	card.reparent(self)
	card.current_pile = self

func remove_card(card: Card):
	card.controller.clicked.disconnect(on_card_click)
	cards.erase(card)
	card.controller.queue_free()

func on_card_click(card: Card):
	try_play.call_deferred($"..", card)
