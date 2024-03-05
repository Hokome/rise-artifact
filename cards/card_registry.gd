class_name CardRegistry extends Node

@export var cards: Array[Card]

func _ready():
	cards.append_array(get_children())

func get_random_cards(count: int, exclusive: bool = true) -> Array[Card]:
	if exclusive and count > cards.size():
		push_error("More cards were asked than available in the pool")
	var array: Array[Card] = []
	for i in count:
		if exclusive: add_random_card_exclusive(array)
		else: array.append(cards.pick_random())
	for i in count:
		array[i] = array[i].duplicate()
	
	return array

func add_random_card_exclusive(array: Array[Card]):
	var card: Card = cards.pick_random()
	while array.has(card):
		card = cards.pick_random()
	array.append(card)
