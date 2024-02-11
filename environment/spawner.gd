class_name Spawner extends Node2D

@export var enemy_scene: PackedScene
@export var enemy_count := 1
@export var enemy_spacing := 1.0

var enemy_list: Array[Enemy] = []
var spawning := false

func _on_game_round_started(game: Game):
	spawning = true
	
	var timer: Timer = Timer.new()
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = enemy_spacing
	add_child(timer)
	
	for i in enemy_count:
		add_enemy(game, enemy_scene.instantiate())
		
		if enemy_count > i + 1:
			timer.start()
			await timer.timeout
	
	spawning = false
	timer.queue_free()

func add_enemy(game: Game, enemy: Enemy):
	%path.add_child(enemy)
	enemy_list.append(enemy)
	enemy.death.connect(remove_enemy)
	enemy.reached_end.connect(game.player_resources().damage)

func remove_enemy(enemy):
	enemy_list.erase(enemy)
	if !spawning and enemy_list.size() == 0:
		$"..".end_round()
