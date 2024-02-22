extends CardPile

@export var max_size: int = 6
@export var card_controller_scene: PackedScene

func add_card(game: Game, card: Card):
	if max_size != 0 and cards.size() == max_size:
		discard(game, cards[0])
	
	var card_controller: CardController = card_controller_scene.instantiate()
	add_child(card_controller)
	card_controller.card = card
	card.controller = card_controller
	
	card_controller.animate_draw(game)
	
	card_controller.clicked.connect(on_card_click)
	cards.append(card)
	card.reparent(self)
	card.current_pile = self

func remove_card(card: Card):
	card.controller.clicked.disconnect(on_card_click)
	cards.erase(card)

func discard(game: Game, card: Card):
	remove_card(card)
	game.discard_pile().add_card(game, card)
	card.controller.animate_discard(game)

func on_card_click(controller: CardController):
	var game = $".."
	if !controller.card.can_play(game):
		return
	
	try_play.call_deferred(game, controller)

func try_play(game: Game, controller: CardController):
	controller.is_selected = true
	if !await controller.card.play(game):
		controller.is_selected = false
