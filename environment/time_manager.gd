class_name TimeManager extends Node

signal on_battle_paused(value: bool)
signal on_battle_resumed()

signal on_game_paused(value: bool)

var game_paused := false:
	set(value):
		if value == game_paused: return
		game_paused = value
		Engine.time_scale = 0 if game_paused else 1

var can_pause_game := false

var battle_paused := true:
	set(value):
		if value == battle_paused: return
		battle_paused = value
		battle_time_scale = 0.0 if battle_paused else 1.0
		on_battle_paused.emit(battle_paused)
		if !battle_paused:
			on_battle_resumed.emit()

var can_pause_battle := false
var battle_time_scale := 1.0


func get_battle_paused() -> bool: return game_paused or battle_paused

func _unhandled_input(event):
	if event is InputEventKey:
		if !event.is_pressed():
			return
		
		if event.keycode == KEY_ESCAPE and can_pause_game:
			game_paused = !game_paused
		
		if event.keycode == KEY_SPACE and can_pause_battle and !game_paused:
			battle_paused = !battle_paused

func create_battle_timer(time: float, one_shot: bool = true, autostart: bool = true) -> BattleTimer:
	var timer = BattleTimer.new()
	timer.wait_time = time
	timer.one_shot = one_shot
	timer.autostart = autostart
	
	timer.setup()
	
	return timer
