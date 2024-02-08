class_name Enemy extends PathFollow2D

@export var base_speed: float = 100

func _process(delta):
	progress += base_speed * delta
	
	if progress_ratio == 1:
		queue_free()
