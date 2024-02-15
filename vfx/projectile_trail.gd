extends Line2D

var projectile: Projectile

func _process(delta):
	var dif = points[1] - points[0]
	if projectile == null:
		width -= width * delta * 50
		if dif.length() <= 10:
			queue_free()
			return
	
	points[0] += dif * delta * 30
