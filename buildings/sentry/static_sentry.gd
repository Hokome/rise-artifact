class_name StaticSentry extends Sentry

func fire():
	pass

func _process(_delta):
	if Game.is_paused or preview:
		return
	
	if !enemies_in_range.is_empty():
		if can_fire:
			fire()
