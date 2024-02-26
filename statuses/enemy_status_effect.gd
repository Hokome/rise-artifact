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

static func apply_status(enemy: Enemy, status: StatusWrapper, status_intensity: int):
	var node := enemy.get_node_or_null(str(status.unique_name))
	if node == null:
		var st: EnemyStatusEffect = status.scene.instantiate()
		st.apply(enemy)
		st.intensity = status_intensity
	else:
		node.intensity += status_intensity

func apply(enemy: Enemy):
	enemy.add_child(self)
	target = enemy
	
	scale = enemy.get_node("sprite").scale
	on_apply()

func on_apply():
	pass

func on_remove():
	pass
