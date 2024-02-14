class_name Game extends Node2D

@export var deck: Array[PackedScene]

static var paused := false:
	set(value):
		paused = value
		Engine.time_scale = 0 if paused else 1

var in_round := false
var current_round := 0

signal battle_started(game: Game)
signal round_started(game: Game)
signal round_ended(game: Game)

func _ready():
	paused = false
	start_battle.call_deferred()

func _input(event):
	if event is InputEventKey:
		if !event.is_pressed():
			return
		
		if event.keycode == KEY_SPACE and !in_round:
			start_round()

func start_battle():
	for card in deck:
		draw_pile().add_card(self, card.instantiate())
	battle_started.emit(self)
	draw_pile().shuffle()
	for i in 4:
		draw_pile().draw_card(self)

func start_round():
	in_round = true
	round_started.emit(self)

func end_round():
	in_round = false
	round_ended.emit(self)
	
	if current_round == spawner().rounds.size() - 1:
		win()
		return
	
	current_round += 1
	for i in 5:
		draw_pile().draw_card(self)

func win():
	%win_lose_label.text = "You win!"
	paused = true
	$hud/main/pause_panel.visible = true

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
func terrain() -> Node2D:
	return %terrain
func spawner() -> Spawner:
	return %spawner
func building_ui() -> BuildingUI:
	return %building_ui

func _on_player_resources_death():
	%win_lose_label.text = "Game Joever"
	paused = true
	$hud/main/pause_panel.visible = true

func _on_restart_button_pressed():
	get_tree().reload_current_scene()
