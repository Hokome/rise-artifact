class_name PlayerController extends Node2D

enum ControlState {
	Default,
	Selecting,
	SelectingUnsnapped,
}

signal prompt_ended

@onready var game: Game = $".."

var control_state: ControlState

var prompt_canceled: bool = false
var selected_tile: Vector2i
var preview_cursor: Node2D
var validate_selection: Callable

func _process(_delta):
	match control_state:
		ControlState.Selecting:
			preview_cursor.global_position = game.grid().map_to_local(game.grid().local_to_map(get_local_mouse_position()))
		ControlState.SelectingUnsnapped:
			preview_cursor.global_position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton:
		if !event.is_pressed():
			return
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			if control_state == ControlState.Selecting:
					var mouse_pos := get_global_mouse_position()
					var grid: TileMap = game.grid()
					selected_tile = grid.local_to_map(mouse_pos)
					
					end_prompt(!validate_selection.call(grid, selected_tile))
					return
			if control_state == ControlState.SelectingUnsnapped:
				end_prompt(false)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if control_state != ControlState.Default:
				end_prompt(true)
		
	
	if event is InputEventKey:
		if !event.is_pressed():
			return
		
		var card_index = get_card_index_input(event.physical_keycode)
		if card_index < 0:
			return
		
		call_deferred("try_play", card_index)

func end_prompt(canceled: bool):
	if preview_cursor is Sprite2D:
		preview_cursor.visible = false
	
	control_state = ControlState.Default
	prompt_canceled = canceled
	prompt_ended.emit()

func get_card_index_input(key) -> int:
	match key:
			KEY_1:
				return 0
			KEY_2:
				return 1
			KEY_3:
				return 2
			KEY_4:
				return 3
			KEY_5:
				return 4
			_:
				return -1

func try_play(card_id: int):
	if control_state != ControlState.Default:
		return
	var hand := game.hand()
	if hand.cards.size() <= card_id:
		return
	hand.try_play(game, hand.cards[card_id])

func select_tile(validate: Callable, preview: Node2D = null):
	if preview == null:
		preview = $tile_cursor
		preview.visible = true
	
	preview_cursor = preview
	
	control_state = ControlState.Selecting
	validate_selection = validate
	
	await prompt_ended
	if prompt_canceled:
		return null
	
	return selected_tile

func select_range(radius: float):
	preview_cursor = $radius_cursor
	preview_cursor.scale = Vector2.ONE * radius / 200.0
	preview_cursor.visible = true
	
	control_state = ControlState.SelectingUnsnapped
	await prompt_ended
	
	if prompt_canceled:
		return null
	
	return get_global_mouse_position()
