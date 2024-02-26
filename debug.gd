class_name DebugScript extends Node2D

#func _ready():
	#get_viewport().size = DisplayServer.screen_get_size()

func _input(event):
	if event is InputEventKey:
		if !event.is_pressed():
			return
		#if event.keycode == KEY_A:
			#$"..".win()
	
