class_name RewardScreen extends MarginContainer

@export var controller_scene: PackedScene

func display_card_rewards(game: Game):
	var rewards = card_registry.get_random_cards(1, Card.filter_building_no_starter)
	var filter = Card.filter_and([Card.filter_no_starter, Card.filter_blacklist([rewards[0]])])
	rewards.append_array(card_registry.get_random_cards_exclusive(2, filter, Card.weight_lower_building))
	for c in rewards:
		var controller: CardController = controller_scene.instantiate()
		controller.card = c
		c.controller = controller
		$hbox/reward/cards.add_child(controller)
		c.controller.clicked.connect(game.on_select_card_reward)
		c.controller.clicked.connect(on_select_card_reward)

func on_select_card_reward(controller: CardController):
	for c in $hbox/reward/cards.get_children():
		if c == controller: continue
		c.card.queue_free()
		c.animate_shrink()

func _on_next_pressed():
	for c in $hbox/reward/cards.get_children():
		if c.card != null: c.card.queue_free()
		c.queue_free()
