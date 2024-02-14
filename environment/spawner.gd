class_name Spawner extends Node2D

@export var rounds: Array[Round]

var enemy_list: Array[Enemy] = []
var waves_left

func _on_game_round_started(game: Game):
	print("round ", game.current_round)
	if game.current_round >= rounds.size():
		return
	var current_round := rounds[game.current_round]
	waves_left = current_round.waves.size()
	for i in current_round.waves.size():
		var wave := current_round.waves[i]
		if wave.delay > 0:
			await get_tree().create_timer(wave.delay).timeout
		spawn_wave.call_deferred(game, wave)

func is_spawning() -> bool:
	return waves_left != 0

func spawn_wave(game: Game, wave: Wave):
	for i in wave.count:
		add_enemy(game, wave.enemy.instantiate())
		if i + 1 < wave.count:
			await get_tree().create_timer(wave.spacing).timeout
	waves_left -= 1

func add_enemy(game: Game, enemy: Enemy):
	%path.add_child(enemy)
	enemy_list.append(enemy)
	enemy.death.connect(remove_enemy)
	enemy.reached_end.connect(game.player_resources().damage)

func remove_enemy(enemy):
	enemy_list.erase(enemy)
	if !is_spawning() and enemy_list.size() == 0:
		$"..".end_round()
