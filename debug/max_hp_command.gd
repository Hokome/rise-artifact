class_name MaxHPCommand extends Command

func can_execute(args) -> bool: return min_args(args, 1)

func execute(args):
	var amount_arg: String = args[0]
	if amount_arg.is_valid_int():
		game().player_stats().max_health = amount_arg.to_int()

