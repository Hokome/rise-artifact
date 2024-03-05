class_name SkipCommand extends Command

func execute(args):
	if args.size() > 0:
		if args[0] == "battle":
			game().skip_battle()
	game().skip_round()
