class_name Card extends Control

@export var title: String
@export var base_cost: int

var current_pile: CardPile = null

func _ready():
	var title_label: Label = $background/card_margin/card_content/header_background/header_content/title_container/title
	title_label.text = title
	
	var cost_label: Label = $background/card_margin/card_content/header_background/header_content/cost_background/cost
	cost_label.text = str(get_cost())

func get_cost() -> int:
	return base_cost

# verifies if the conditions to play the cards are met
func can_play(game: Game) -> bool:
	return game.player_resources().power >= get_cost()
# applies the effect of the card
func play(game: Game):
	discard(game)

func get_description() -> String:
	return "Placeholder description"

func discard(game: Game):
	current_pile.remove_card(self)
	game.discard_pile().add_card(self)
