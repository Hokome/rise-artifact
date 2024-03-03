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

func set_description(rtl: RichTextLabel):
	rtl.append_text("Upgrade a building ")
	rtl.append_text(str(upgrade_count))
	rtl.append_text(" time")

static func validate_selection(grid: GameGrid, pos: Vector2i) -> bool:
	if !grid.in_bounds(pos):
		return false
	
	return grid.get_building_at(pos) != null
