class_name PlayerController extends Node2D

enum ControlState {
	Default,
	Placing,
}

signal prompt_ended

@onready var game: Game = $".."

var control_state: ControlState

var prompt_canceled: bool = false
var selected_pos: Vector2i
var previewed_building: Building
var validate_placement: Callable

func _process(_delta):
	if control_state == ControlState.Placing:
		previewed_building.global_position = game.grid().map_to_local(game.grid().local_to_map(get_local_mouse_position()))

func _input(event):
	if event is InputEventMouseButton:
		if !event.is_pressed():
			return
		if control_state == ControlState.Placing:
			if event.button_index == MOUSE_BUTTON_LEFT:
				var mouse_pos := get_global_mouse_position()
				var grid: TileMap = %grid
				selected_pos = grid.local_to_map(mouse_pos)
				
				end_prompt(!validate_placement.call(grid, selected_pos))
				
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
	if hand.cards.size() <= card_id:
		return
	hand.try_play(game, hand.cards[card_id])

func place_building(preview: Building, validate: Callable):
	control_state = ControlState.Placing
	previewed_building = preview
	validate_placement = validate
	
	await prompt_ended
	if prompt_canceled:
		return null
	
	return selected_pos
