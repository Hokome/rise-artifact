class_name DebugScript extends Node2D

@export var enemy_scene: PackedScene

func _input(event):
	if event is InputEventKey:
		if !event.is_pressed():
			return
		if event.keycode == KEY_SPACE:
			var enemy = enemy_scene.instantiate()
			%path.add_child(enemy)
			enemy.position = Vector2.ZERO
	
