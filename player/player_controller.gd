class_name PlayerController extends Node2D

enum ControlState {
	Default,
	Placing,
}

signal prompt_ended

@onready var game: Game = $".."

var control_state: ControlState

var prompt_canceled: bool = false
var selected_tile: Vector2i

func _process(_delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if !event.is_pressed():
			return
		if control_state == ControlState.Placing:
			if event.button_index == MOUSE_BUTTON_LEFT:
				var mouse_pos := get_global_mouse_position()
				var grid: GameGrid = %grid
				selected_tile = grid.global_to_grid(mouse_pos)
				end_prompt(false)
			if event.button_index == MOUSE_BUTTON_RIGHT:
				end_prompt(true)
	
	if event is InputEventKey:
		if !event.is_pressed():
			return
		
		var card_index = get_card_index_input(event.physical_keycode)
		if card_index < 0:
			return
		
		call_deferred("try_play", card_index)

func end_prompt(canceled: bool):
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
	hand.try_play(game, card_id)

func select_grid_position():
	control_state = ControlState.Placing
	
	await prompt_ended
	if prompt_canceled:
		return null
	
	return selected_tile
