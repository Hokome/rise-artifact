class_name CardCommand extends Command

func can_execute(args) -> bool:
	if !min_args(args, 1): return false
	return card_registry.exists(args[0])

func execute(args):
	var card: Card = card_registry.get_copy(args[0])
	game().hand().add_card(game(), card)
