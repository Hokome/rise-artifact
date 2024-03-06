class_name Spawner extends Node2D

var rounds: Array[Round]

var enemy_list: Array[Enemy] = []
var waves_left
var aborted := false

var ramping: int

signal round_aborted()
signal done_spawning()

func _on_game_round_started(game: Game):
	if aborted: return
	if game.current_round >= rounds.size():
		return
	var current_round := rounds[game.current_round]
	waves_left = current_round.waves.size()
	for i in current_round.waves.size():
		if aborted: return
		var wave := current_round.waves[i]
		if wave.delay > 0:
			var timer := time_manager.create_battle_timer(wave.delay)
			add_child(timer)
			await timer.timeout
			timer.queue_free()
		
		spawn_wave.call_deferred(game, wave)
	
	await done_spawning
	
	var end_timer := time_manager.create_battle_timer(4)
	add_child(end_timer)
	await end_timer.timeout
	end_timer.queue_free()
	$"..".timeout_round()

func is_spawning() -> bool:
	return waves_left != 0

func spawn_wave(game: Game, wave: Wave):
	for i in wave.count:
		if aborted: return
		add_enemy(game, wave.enemy.enemy_scene.instantiate())
		if i + 1 < wave.count:
			var timer := time_manager.create_battle_timer(wave.spacing)
			add_child(timer)
			await timer.timeout
			timer.queue_free()
	waves_left -= 1
	if waves_left == 0:
		done_spawning.emit()

func add_enemy(game: Game, enemy: Enemy):
	game.map.get_node("path").add_child(enemy)
	enemy_list.append(enemy)
	enemy.set_ramping(ramping)
	enemy.death.connect(remove_enemy)
	enemy.reached_end.connect(game.player_resources().damage)

func remove_enemy(enemy):
	enemy_list.erase(enemy)
	if !is_spawning() and enemy_list.size() == 0:
		$"..".end_round()

func stop():
	aborted = true
	var c := get_child_count()
	for i in c:
		get_child(0).queue_free()
	round_aborted.emit()
	done_spawning.emit()

func kill_all():
	var count = enemy_list.size()
	for i in count:
		enemy_list[0].kill()
