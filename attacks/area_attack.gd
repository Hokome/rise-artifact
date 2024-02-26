class_name AreaAttack extends Node2D

var shape: Shape2D:
	get:
		return $cast.shape
	set(value):
		$cast.shape = value

var damage: int

func execute():
	var cast: ShapeCast2D = $cast
	cast.force_shapecast_update()
	var result = $cast.collision_result
	for col: Dictionary in result:
		var parent = col.collider.get_parent()
		if parent is Enemy:
			apply_effect(parent)

func apply_effect(enemy: Enemy):
	enemy.damage(damage)
