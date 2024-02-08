class_name DebugScript extends Node2D

func _input(event):
	if event is InputEventKey:
		if !event.is_pressed():
			return
		
		if event.keycode == KEY_A and $"..".in_round:
			var spawner: Spawner = %spawner
			if spawner.enemy_list.size() == 0:
				return
			var enemy: Enemy = spawner.enemy_list[0]
			enemy.kill()
	
