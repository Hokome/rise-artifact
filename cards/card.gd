class_name Card extends Node

@export var title: String
@export var illustration: Texture2D
@export var base_cost: int

var current_pile: CardPile = null
var controller: CardController

func get_cost() -> int:
	return base_cost

# verifies if the conditions to play the cards are met
func can_play(game: Game) -> bool:
	return game.player_resources().power >= get_cost()
# applies the effect of the card
func play(game: Game):
	consume_power(game)
	discard(game)

func set_description(rtl: RichTextLabel):
	rtl.append_text("Placeholder description")

func consume_power(game: Game):
	game.player_resources().power -= get_cost()

func discard(game: Game):
	current_pile.remove_card(self)
	game.discard_pile().add_card(game, self)
