extends CanvasLayer

@export var game_scene: PackedScene

func _on_start_button_pressed():
	get_tree().change_scene_to_packed(game_scene)

func _on_exit_button_pressed():
	get_tree().quit()


func _on_close_button_pressed():
	$main_control/tutorial_panel.visible = false

func _on_tutorial_button_pressed():
	$main_control/tutorial_panel.visible = true
