extends Path2D

func _ready():
	var l := Line2D.new()
	l.default_color = Color.DIM_GRAY
	l.width = 64
	for point in curve.get_baked_points():
		l.add_point(point + position)
	get_parent().call_deferred("add_child", l)
	get_parent().call_deferred("move_child", l, 0)
