class_name Enemy extends PathFollow2D

@export var base_speed: float = 100

signal death(Enemy)

func _process(delta):
	progress += base_speed * delta
	
	if progress_ratio == 1:
		remove()

func kill():
	remove()

func remove():
	death.emit(self)
	queue_free()
