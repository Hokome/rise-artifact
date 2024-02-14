class_name Projectile extends Area2D

var damage: int
var speed: float
var direction: Vector2
var trail: Line2D:
	set(val):
		trail = val
		trail.projectile = self

var max_distance: float
var traveled_distance: float = 0

func _process(delta):
	var distance = delta * speed
	var translation = direction * distance
	trail.points[1] += translation
	translate(translation)
	traveled_distance += distance

func _physics_process(_delta):
	if traveled_distance >= max_distance:
		queue_free()

func hit(enemy: Enemy):
	enemy.damage(damage)

func _on_area_entered(area):
	var parent = area.get_parent()
	if parent is Enemy:
		hit(parent)
		queue_free()
