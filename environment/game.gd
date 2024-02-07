class_name Game extends Node2D

signal PromptComplete

func _ready():
	for i in 5:
		draw_pile().draw_card(self)

func _process(_delta):
	PromptComplete.emit()
	pass

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
