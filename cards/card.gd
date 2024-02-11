class_name Card extends Control

signal clicked(Card)

const HOVER_SCALE: Vector2 = Vector2.ONE * 1.2

@export var title: String
@export var base_cost: int

var current_pile: CardPile = null

var is_hovered := false

func _ready():
	var title_label: Label = %title
	title_label.text = title
	
	var cost_label: Label = %cost
	cost_label.text = str(get_cost())
	
	var desc_label: RichTextLabel = %description
	desc_label.text = ""
	set_description(desc_label)

func _input(event):
	if is_hovered and event is InputEventMouseButton:
		if !event.is_pressed():
			return
		if event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(self)

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

func _on_background_mouse_entered():
	is_hovered = true
	var offset = $offset
	
	offset.z_index = 1
	offset.scale = HOVER_SCALE
	

func _on_background_mouse_exited():
	is_hovered = false
	var offset = $offset
	
	offset.z_index = 0
	offset.scale = Vector2.ONE
	
