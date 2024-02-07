extends Card

@export var building_scene: PackedScene

func play(game: Game):
	var selected_position = await game.player_controller().select_grid_position()
	
	if selected_position == null:
		return
	
	var building: Building = building_scene.instantiate()
	var grid := game.grid()
	grid.add_child(building)
	building.position = grid.grid_to_local(selected_position)
	
	discard(game)
