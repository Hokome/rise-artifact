extends Card

@export_multiline var message = "debug card was played"

func play(game: Game):
	print(message);
	discard(game)

func get_description() -> String:
	return "Prints a message to the dev console"
