class_name BattleTimer extends Timer

func setup():
	paused = time_manager.battle_paused
	time_manager.on_battle_paused.connect(set_paused)

func _exit_tree():
	time_manager.on_battle_paused.disconnect(set_paused)
