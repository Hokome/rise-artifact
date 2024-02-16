class_name Game extends Node2D

@export var maps: Array[PackedScene]
@export var generator: RoundGenerator

static var is_paused := false
var paused := false:
	set(value):
		paused = value
		is_paused = value
		$hud/main/pause_panel.visible = value
		Engine.time_scale = 0 if paused else 1

var can_pause := true

var in_round := false
var game_ended := false
var current_round := 0
var map: Node2D

signal battle_loaded(game: Game)
signal battle_started(game: Game)
signal round_started(game: Game)
signal round_ended(game: Game)

func _ready():
	paused = false
	WavePattern.initialize_patterns()
	player_arsenal().leftover_health = player_stats().max_health
	
	load_map()

func _input(event):
	if event is InputEventKey:
		if !event.is_pressed():
			return
		
		if event.keycode == KEY_ESCAPE and can_pause:
			paused = !paused
		
		if event.keycode == KEY_SPACE and !in_round:
			start_round()

func load_map():
	map = maps.pick_random().instantiate()
	add_child(map)
	
	player_resources().stats = player_stats()
	
	battle_started.connect(player_resources()._on_game_battle_started)
	round_ended.connect(player_resources()._on_game_round_ended)
	
	spawner().rounds = generator.generate()
	battle_loaded.emit(self)
	
	start_battle.call_deferred()

func cleanup_map():
	print("cleanup")
	battle_started.disconnect(player_resources()._on_game_battle_started)
	round_ended.disconnect(player_resources()._on_game_round_ended)
	
	delete_pile().remove_all()
	draw_pile().remove_all()
	discard_pile().remove_all()
	hand().remove_all()
	
	map.queue_free()

func start_battle():
	battle_started.emit(self)
	draw_pile().shuffle()
	for i in 4:
		draw_pile().draw_card(self)
	current_round = 0

func start_round():
	in_round = true
	round_started.emit(self)

func _exit_tree():
	paused = false

func end_round():
	print("end round")
	in_round = false
	round_ended.emit(self)
	
	if current_round == spawner().rounds.size() - 1 and player_resources().health > 0:
		win()
		return
	
	current_round += 1
	for i in 4:
		draw_pile().draw_card(self)

func win():
	if game_ended:
		return
	%win_lose_label.text = "You win!"
	player_arsenal().leftover_health = player_resources().health
	end_battle()

func end_battle():
	game_ended = true
	can_pause = false
	$hud/main/end_panel.visible = true

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
	return map.get_node("player_resources")
func player_stats() -> PlayerStats:
	return %player_stats
func player_arsenal() -> PlayerArsenal:
	return %player_arsenal

func grid() -> GameGrid:
	return map.get_node("grid")
func spawner() -> Spawner:
	return %spawner
func building_ui() -> BuildingUI:
	return %building_ui

func _on_player_resources_death():
	%win_lose_label.text = "Game Owover x3"
	end_battle()

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_resume_button_pressed():
	if can_pause:
		paused = false

func _on_exit_button_pressed():
	paused = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func _on_next_button_pressed():
	game_ended = false
	$hud/main/end_panel.visible = false
	cleanup_map()
	
	load_map.call_deferred()
