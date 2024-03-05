extends Line2D

var lifetime: float

var tail: Vector2

func _enter_tree():
	tail = points[0]
	
	var tail_tween := create_tween()
	tail_tween.tween_property(self, "tail", Vector2.ZERO, lifetime)
	tail_tween.tween_callback(queue_free)
	
	var size_tween := create_tween()
	size_tween.tween_property(self, "width", 0.0, lifetime)

func _process(_delta):
	points[0] = tail
