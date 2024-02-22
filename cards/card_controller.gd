class_name CardController extends Control

signal clicked(controller: CardController)

const CARD_OFFSET := Vector2(640, 170)

const HOVER_SCALE: Vector2 = Vector2.ONE * 1.2
const HOVER_TWEEN_TIME: float = 0.2

const SELECT_OFFSET: Vector2 = Vector2.LEFT * 40
const SELECT_TWEEN_TIME: float = 0.1

const DRAW_TWEEN_TIME: float = 0.5

const DISCARD_TWEEN_TIME: float = 0.5
const DISCARD_SCALE: Vector2 = Vector2.ONE * 0.1

var is_hovered := false:
	set(value):
		is_hovered = value
		if is_selected: return
		
		animate_hover() if value else animate_reset()
		
		z_index = 1 if is_hovered else 0

var is_selected := false:
	set(value):
		is_selected = value
		
		animate_select(value) if is_hovered else animate_reset()

var pos_tween: Tween:
	set(value):
		if pos_tween:
			pos_tween.stop()
		pos_tween = value
var scale_tween: Tween:
	set(value):
		if scale_tween:
			scale_tween.stop()
		scale_tween = value

var card: Card:
	set(value):
		card = value
		var title_label: Label = %title
		title_label.text = card.title

		var cost_label: Label = %cost
		cost_label.text = str(card.get_cost())

		var desc_label: RichTextLabel = %description
		desc_label.text = ""
		card.set_description(desc_label)

		var illust_rect: TextureRect = %illustration
		illust_rect.texture = card.illustration

func animate_select(value: bool):
	var offset: Node2D = $offset
	offset.scale = HOVER_SCALE
	
	var final_pos := CARD_OFFSET
	if value:
		final_pos += SELECT_OFFSET
	
	pos_tween = create_tween()
	pos_tween.tween_property($offset, "position", final_pos, SELECT_TWEEN_TIME)

func animate_hover():
	var offset: Node2D = $offset
	
	scale_tween = create_tween()
	var prop = scale_tween.tween_property($offset, "scale", HOVER_SCALE, HOVER_TWEEN_TIME)
	prop.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func animate_reset():
	var offset: Node2D = $offset
	
	pos_tween = create_tween()
	var prop := pos_tween.tween_property(offset, "position", CARD_OFFSET, HOVER_TWEEN_TIME)
	prop.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	scale_tween = create_tween()
	prop = scale_tween.tween_property(offset, "scale", Vector2.ONE, HOVER_TWEEN_TIME)
	prop.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func animate_draw(game: Game):
	var offset := $offset
	var draw_pile := game.draw_pile()
	
	offset.global_position = draw_pile.global_position
	
	pos_tween = create_tween()
	var prop := pos_tween.tween_property(offset, "position", CARD_OFFSET, DRAW_TWEEN_TIME)
	prop.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	scale_tween = create_tween()
	prop = scale_tween.tween_property(offset, "scale", Vector2.ONE, DRAW_TWEEN_TIME)
	prop.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func animate_discard(game: Game):
	var offset := $offset
	var discard_pile := game.discard_pile()
	reparent(discard_pile)
	
	pos_tween = create_tween()
	var prop := pos_tween.tween_property(offset, "global_position", discard_pile.global_position, DISCARD_TWEEN_TIME)
	prop.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	scale_tween = create_tween()
	prop = scale_tween.tween_property(offset, "scale", DISCARD_SCALE, DISCARD_TWEEN_TIME)
	prop.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	scale_tween.finished.connect(queue_free)

func _input(event):
	if is_hovered and event is InputEventMouseButton:
		if !event.is_pressed():
			return
		if event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(self)

func _on_background_mouse_entered():
	is_hovered = true

func _on_background_mouse_exited():
	is_hovered = false
