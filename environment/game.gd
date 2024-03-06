class_name Game extends Node2D

@export var maps: Array[PackedScene]
@export var generator: RoundGenerator
const DEFAULT_DRAW_COUNT := 5

var in_round := false
var is_round_prepared := false
var game_ended := false
var current_round := 0
var map: Node2D

signal battle_loaded(game: Game)
signal battle_started(game: Game)
signal round_prepared(game: Game)
signal round_started(game: Game)
signal round_ended(game: Game)

func _ready():
	time_manager.game_paused = false
	time_manager.can_pause_game = true
	
	Round.initialize_rounds()
	player_arsenal().leftover_health = player_stats().max_health
	
	load_map()

func load_map():
	map = maps.pick_random().instantiate()
	add_child(map)
	
	player_resources().stats = player_stats()
	
	battle_started.connect(player_resources()._on_game_battle_started)
	round_prepared.connect(player_resources()._on_game_round_prepared)
	player_resources().death.connect(lose)
	
	spawner().rounds = generator.generate()
	battle_loaded.emit(self)
	
	start_battle.call_deferred()

func cleanup_map():
	battle_started.disconnect(player_resources()._on_game_battle_started)
	round_prepared.disconnect(player_resources()._on_game_round_prepared)
	
	delete_pile().remove_all()
	draw_pile().remove_all()
	discard_pile().remove_all()
	hand().remove_all()
	
	map.queue_free()

func start_battle():
	spawner().ramping = 0
	is_round_prepared = false
	
	time_manager.battle_paused = true
	time_manager.can_pause_battle = true
	
	battle_started.emit(self)
	draw_pile().shuffle()
	prepare_round()
	current_round = 0
	
	spawner().aborted = false
	
	time_manager.on_battle_resumed.connect(start_round)

func prepare_round():
	if is_round_prepared: return
	is_round_prepared = true
	round_prepared.emit(self)
	for i in DEFAULT_DRAW_COUNT:
		draw_pile().draw_card(self)

func start_round():
	if time_manager.on_battle_resumed.is_connected(start_round):
		time_manager.on_battle_resumed.disconnect(start_round)
	
	is_round_prepared = false
	if game_ended:
		return
	in_round = true
	round_started.emit(self)

func timeout_round():
	if current_round < spawner().rounds.size() - 1:
		end_round()
		prepare_round()
		start_round()

func finish_round():
	if current_round == spawner().rounds.size() - 1:
		end_round()
		return
	prepare_round()

func end_round():
	
	in_round = false
	round_ended.emit(self)
	
	if current_round == spawner().rounds.size() - 1 and player_resources().health > 0:
		win()
		return
	hand().discard_all(self)
	
	current_round += 1
	spawner().ramping += 1

#func skip_round():
	#spawner().stop()
	#spawner().kill_all()
	#end_round()

func skip_battle():
	if time_manager.on_battle_resumed.is_connected(start_round):
		time_manager.on_battle_resumed.disconnect(start_round)
	spawner().stop()
	spawner().kill_all()
	win()

func win():
	if game_ended:
		return
	
	player_arsenal().leftover_health = player_resources().health
	end_battle()
	for i in generator.budgets.size():
		generator.budgets[i] *= 1.4
	%reward_screen.visible = true
	%reward_screen.display_card_rewards(self)
func lose():
	if game_ended:
		return
	end_battle()
	%game_over_screen.visible = true

func end_battle():
	game_ended = true
	time_manager.battle_paused = true
	time_manager.can_pause_battle = false
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

func _exit_tree():
	time_manager.game_paused = false

func on_select_card_reward(controller: CardController):
	player_arsenal().add_card_to_deck(controller.card)
	
	controller.card = null
	controller.animate_fade()

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_resume_button_pressed():
	if time_manager.can_pause_battle:
		time_manager.game_paused = false

func _on_exit_button_pressed():
	time_manager.game_paused = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func _on_next_pressed():
	game_ended = false
	%reward_screen.visible = false
	$hud/main/end_panel.visible = false
	cleanup_map()
	
	load_map.call_deferred()
