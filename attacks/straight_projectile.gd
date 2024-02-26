extends Projectile

var max_distance: float
var traveled_distance: float = 0

func _process(delta):
	var distance = delta * speed
	var translation = direction * distance
	translate(translation)
	traveled_distance += distance

func _physics_process(_delta):
	if traveled_distance >= max_distance:
		queue_free()
