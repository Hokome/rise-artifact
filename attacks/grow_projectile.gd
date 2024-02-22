extends Projectile

var min_size: float
var max_size: float
var lifetime: float:
	set(value):
		lifetime = value
		timer = Timer.new()
		add_child(timer)
		timer.wait_time = lifetime
		timer.one_shot = true
		timer.autostart = true
		timer.timeout.connect(expire)

var timer: Timer

func _process(delta):
	var distance = delta * speed
	var translation = direction * distance
	scale = Vector2.ONE * lerpf(min_size, max_size, (lifetime - timer.time_left) / lifetime) / 2.0
	translate(translation)

func expire():
	queue_free()
