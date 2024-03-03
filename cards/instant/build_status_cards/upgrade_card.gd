extends Card

@export var upgrade_count := 1

func play(game: Game) -> bool:
	var selected_position = await game.player_controller().select_tile(validate_selection)
	
	if selected_position == null:
		return false
	
	var building: Building = game.grid().get_building_at(selected_position)
	building.upgrades += upgrade_count
	
	consume_power(game)
	discard(game)
	
	return true

func get_formatter() -> Dictionary: return {"count":upgrade_count}

func get_default_description() -> String: return "Apply {count} [color=[cyan]]Upgrade[/color]"

static func validate_selection(grid: GameGrid, pos: Vector2i) -> bool:
	if !grid.in_bounds(pos):
		return false
	
	return grid.get_building_at(pos) != null
