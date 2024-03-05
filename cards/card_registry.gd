class_name CardRegistry extends Node

@export var cards: Dictionary

class CardCandidate:
	var card: Card
	var weight: float

class CardPool:
	var list: Array[CardCandidate] = []
	var total_weight: float
	
	func add_cards(card_list: Array):
		for card in card_list:
			var candidate := CardCandidate.new()
			candidate.card = card
			list.append(candidate)
	
	func add_weights(weighting_function: Callable):
		for candidate in list:
			candidate.weight = weighting_function.call(candidate.card)
			#print("card: ", candidate.card.unique_name, ", weight: ", candidate.weight)
			total_weight += candidate.weight
	
	func get_random(exclusive: bool = false) -> Card:
		var random_val := randf_range(0.0, total_weight)
		for i in list.size():
			var candidate := list[i]
			random_val -= candidate.weight
			if random_val < 0.0:
				if exclusive:
					total_weight -= candidate.weight
					list.remove_at(i)
				return candidate.card
		var last_candidate: CardCandidate = list.back()
		if exclusive:
			total_weight -= last_candidate.weight
			list.remove_at(list.size() - 1)
		return last_candidate.card

func _ready():
	for card: Card in get_children():
		cards[card.unique_name] = card

func get_random_cards_exclusive(count: int, filter: Callable = Card.filter_all, weighting: Callable = Card.weight_neutral) -> Array[Card]:
	if count > cards.size():
		push_error("More cards were asked than available in registry")
	
	var selection: Array = cards.values().filter(filter)
	if count > selection.size():
		push_error("There are less cards that pass the filter than are asked for")
	
	var pool: CardPool = CardPool.new()
	pool.add_cards(selection)
	pool.add_weights(weighting)
	
	var array: Array[Card] = []
	for i in count:
		array.append(pool.get_random(true).duplicate())
	
	return array

func get_random_cards(count: int, filter: Callable = Card.filter_all, weighting: Callable = Card.weight_neutral) -> Array[Card]:
	var selection: Array = cards.values().filter(filter)
	if selection.size() == 0:
		push_error("There are no cards that pass the filter")
		
	var pool: CardPool = CardPool.new()
	pool.add_cards(selection)
	pool.add_weights(weighting)
	
	var array: Array[Card] = []
	for i in count:
		array.append(pool.get_random().duplicate())
	
	return array

func exists(unique_name: String) -> bool: return cards.has(unique_name)
func get_copy(unique_name: String) -> Card: return cards[unique_name].duplicate()
