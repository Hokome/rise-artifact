extends CardPile

@export var controller_scene: PackedScene
@export var max_size: int = 6

func add_card(game: Game, card: Card):
	if max_size != 0 and cards.size() == max_size:
		discard(game, cards[0])
	
	var card_controller: CardController = controller_scene.instantiate()
	add_child(card_controller)
	card_controller.card = card
	card.controller = card_controller
	
	card_controller.animate_draw(game)
	
	card_controller.clicked.connect(on_card_click)
	cards.append(card)
	if card.get_parent() != null:
		card.reparent(self)
	else:
		add_child(card)
	card.current_pile = self

func remove_card(card: Card):
	card.controller.clicked.disconnect(on_card_click)
	cards.erase(card)

func remove_all():
	for card_id in cards.size():
		remove_card(cards[0])
	cards.clear()
	for child in get_children():
		child.queue_free()

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
	
	@warning_ignore("redundant_await")
	if !await controller.card.play(game):
		if controller == null:
			return
		controller.is_selected = false
