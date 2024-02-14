class_name CardController extends Control

signal clicked(Card)

const HOVER_SCALE: Vector2 = Vector2.ONE * 1.2

var is_hovered := false

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

func _input(event):
	if is_hovered and event is InputEventMouseButton:
		if !event.is_pressed():
			return
		if event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(card)

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
