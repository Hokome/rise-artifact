class_name Card extends Node

@export var title: String
@export var illustration: Texture2D
@export var base_cost: int
@export_multiline var description: String 

var current_pile: CardPile = null
var controller: CardController

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
