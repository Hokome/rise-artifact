extends Card

@export var building_wrapper: BuildingWrapper

func play(game: Game) -> bool:
	var building: Building = building_wrapper.instantiate()
	var grid := game.grid()
	building.preview = true
	grid.add_child(building)
	
	var selected_position = await game.player_controller().select_tile(validate_placement, building)
	
	if selected_position == null:
		building.queue_free()
		return false
	
	grid.add_building(building, selected_position)
	building.preview = false
	
	consume_power(game)
	discard(game)
	return true

func get_formatter() -> Dictionary: return {"building": building_wrapper.display_name}

func get_default_description() -> String: return "Place 1 [color=cyan]{building}[/color]"

static func validate_placement(grid: GameGrid, pos: Vector2i) -> bool:
	if !grid.in_bounds(pos):
		return false
	
	var selected_tile := grid.get_cell_tile_data(GameGrid.TERRAIN_LAYER, pos)
	if selected_tile == null:
		return false
	
	if !selected_tile.get_custom_data("can_build"):
		return false
	
	return grid.get_building_at(pos) == null
