extends Card

@export_multiline var message = "debug card was played"

func play(game: Game) -> bool:
	print(message)
	consume_power(game)
	discard(game)
	
	return true

