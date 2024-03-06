class_name Card extends Node



@export_category("Card info")
@export var title: String
@export var illustration: Texture2D
@export var base_cost: int
@export_multiline var description: String 

@export_category("Card metadata")
@export var unique_name: StringName
@export var is_starter := false
@export var is_build_card := false

var current_pile: CardPile = null
var controller: CardController

signal on_discard(card: Card)

func get_cost() -> int:
	return base_cost

# verifies if the conditions to play the cards are met
func can_play(game: Game) -> bool:
	return game.player_resources().power >= get_cost()
# applies the effect of the card
func play(game: Game) -> bool:
	consume_power(game)
	discard(game)
	return true

func get_formatter() -> Dictionary: return {}

func get_description() -> String:
	var desc = description
	if desc.is_empty():
		desc = get_default_description()
	return parse_description(desc.format(get_formatter()))

func get_default_description() -> String:
	return "placeholder"

func parse_description(desc: String) -> String:
	desc = desc.replace("[red]", "red")
	desc = desc.replace("[cyan]", "cyan")
	return desc

func consume_power(game: Game):
	game.player_resources().power -= get_cost()

func discard(game: Game):
	current_pile.discard(game, self)

static func filter_and(filters: Array[Callable]) -> Callable:
	return func(card: Card):
		for f in filters:
			if !f.call(card):
				return false
		return true

static func filter_blacklist(blacklisted_cards: Array[Card]) -> Callable:
	return func(card: Card): return !blacklisted_cards.has(card)

static func filter_all(_card: Card) -> bool: return true
static func filter_no_starter(card: Card) -> bool: return !card.is_starter
static func filter_building_no_starter(card: Card) -> bool: return card.is_build_card and !card.is_starter

static func weight_neutral(_card: Card) -> float: return 1.0
static func weight_lower_building(card: Card) -> float: return 0.2 if card.is_build_card else 1.0
