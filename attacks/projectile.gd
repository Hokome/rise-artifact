class_name Projectile extends Area2D

@export var pierce := 1

var damage: int
var speed: float
var direction: Vector2

func hit(enemy: Enemy):
	enemy.damage(damage)

func _on_area_entered(area):
	if pierce == 0:
		return
	var parent = area.get_parent()
	if parent is Enemy:
		hit(parent)
		pierce -= 1
		if pierce == 0:
			queue_free()
