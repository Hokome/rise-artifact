extends Line2D

var projectile: Projectile

func _process(delta):
	var dif = points[1] - points[0]
	if dif.length() <= 20 and projectile == null:
		queue_free()
		return
	
	points[0] += dif * delta * 30
