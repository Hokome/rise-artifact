extends Card

@export var aspect: Aspect

func play(game: Game) -> bool:
	var selected_position = await game.player_controller().select_tile(validate_selection)
	
	if selected_position == null:
		return false
	
	var sentry: Sentry = game.grid().get_building_at(selected_position)
	aspect.modify_sentry(sentry)
	
	consume_power(game)
	discard(game)
	
	return true

static func validate_selection(grid: GameGrid, pos: Vector2i) -> bool:
	if !grid.in_bounds(pos):
		return false
	
	var building = grid.get_building_at(pos)
	return building is Sentry
