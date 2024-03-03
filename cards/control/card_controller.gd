class_name CardController extends Control

signal clicked(controller: CardController)

@export var hover_scale: float = 1.4
@export var hover_offset: Vector2
@export var hover_tween_time: float = 0.2

@export var select_tween_time: float = 0.1

@export var draw_tween_time: float = 0.5

@export var discard_scale: float = 0.1
@export var discard_tween_time: float = 0.5

@export var shrink_tween_time: float = 0.4

@onready var card_offset: Vector2 = $offset.position
@onready var card_scale: float = $offset.scale.x

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
var color_tween: Tween:
	set(value):
		if color_tween:
			color_tween.stop()
		color_tween = value

var card: Card:
	set(value):
		card = value
		if card == null: return
		
		var visual := $offset/visual
		visual.set_title(card.title)
		visual.set_cost(card.get_cost())
		visual.set_illustration(card.illustration)
		
		var desc_label = visual.get_description_label()
		desc_label.text = ""
		card.set_description(desc_label)

var enabled := true

func animate_select(value: bool):
	var offset: Node2D = $offset
	offset.scale = Vector2.ONE * hover_scale
	
	var color = Color(1, 1, 1, 0.5) if value else Color.WHITE
	var pos = card_offset if value else (hover_offset + card_offset)
	
	color_tween = create_tween()
	color_tween.tween_property(self, "modulate", color, select_tween_time)
	
	animate(select_tween_time, hover_scale, pos)

func animate_hover(): animate(hover_tween_time, hover_scale, card_offset + hover_offset)

func animate_reset():
	color_tween = create_tween()
	color_tween.tween_property(self, "modulate", Color.WHITE, select_tween_time)
	animate(hover_tween_time)

func animate(time: float, target_scale = card_scale, target_pos = card_offset):
	var offset: Node2D = $offset
	
	if target_pos != null:
		pos_tween = create_tween()
		var prop := pos_tween.tween_property(offset, "position", target_pos, time)
		prop.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	if target_scale != null:
		scale_tween = create_tween()
		var prop = scale_tween.tween_property(offset, "scale", Vector2.ONE * target_scale, time)
		prop.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func animate_draw(game: Game):
	var offset := $offset
	var draw_pile := game.draw_pile()
	
	offset.global_position = draw_pile.global_position
	
	pos_tween = create_tween()
	var prop := pos_tween.tween_property(offset, "position", card_offset, draw_tween_time)
	prop.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	scale_tween = create_tween()
	prop = scale_tween.tween_property(offset, "scale", Vector2.ONE, draw_tween_time)
	prop.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func animate_discard(game: Game):
	var offset := $offset
	var discard_pile := game.discard_pile()
	reparent(discard_pile)
	
	pos_tween = create_tween()
	var prop := pos_tween.tween_property(offset, "global_position", discard_pile.global_position, discard_tween_time)
	prop.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	scale_tween = create_tween()
	prop = scale_tween.tween_property(offset, "scale", Vector2.ONE * discard_scale, discard_tween_time)
	prop.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	scale_tween.finished.connect(queue_free)

func animate_shrink():
	enabled = false
	animate(shrink_tween_time, 0.001)
	await scale_tween.finished

func animate_fade():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, shrink_tween_time).finished.connect(queue_free)


func _input(event):
	if !enabled: return
	if is_hovered and event is InputEventMouseButton:
		if !event.is_pressed():
			return
		if event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(self)

func _on_visual_mouse_entered():
	if !enabled: return
	is_hovered = true

func _on_visual_mouse_exited():
	if !enabled: return
	is_hovered = false
