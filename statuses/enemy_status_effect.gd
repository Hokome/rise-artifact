class_name EnemyStatusEffect extends StatusEffect

signal intensity_changed(value: int)

var target: Enemy
var intensity: int:
	set(value):
		intensity = value
		intensity_changed.emit(intensity)
		if intensity <= 0:
			on_remove()
			queue_free()

func apply(enemy: Enemy):
	enemy.add_child(self)
	target = enemy
	
	scale = enemy.get_node("sprite").scale
	on_apply()

func on_apply():
	pass

func on_remove():
	pass
