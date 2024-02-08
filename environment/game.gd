class_name Game extends Node2D

var in_round := false
var current_round := 0

signal round_started
signal round_ended

func _input(event):
	if event is InputEventKey:
		if !event.is_pressed():
			return
		
		if event.keycode == KEY_SPACE and !in_round:
			start_round()

func start_round():
	current_round += 1
	for i in 5:
		draw_pile().draw_card(self)
	in_round = true
	round_started.emit()

func end_round():
	in_round = false
	print("round ended")
	round_ended.emit()

func hand() -> CardPile:
	return %hand
func draw_pile() -> CardPile:
	return %draw_pile
func discard_pile() -> CardPile:
	return %discard_pile
func delete_pile() -> CardPile:
	return %delete_pile

func player_controller() -> PlayerController:
	return %player_controller
func player_resources() -> PlayerResources:
	return %player_resources
func player_stats() -> PlayerStats:
	return %player_stats

func grid() -> GameGrid:
	return %grid
func spawner() -> Spawner:
	return %spawner
