class_name TargetingSentry extends Sentry

@export var base_projectile_speed: float = 100.0

func _process(_delta):
	if Game.is_paused or preview:
		return
	
	var target = get_target_pos()
	if target != null:
		$gun.look_at(target)
		if can_fire:
			fire(target)

func fire(_target: Vector2):
	pass

func get_target_pos():
	if enemies_in_range.size() == 0:
		return null
	var best_enemy := enemies_in_range[0]
	match targeting:
		Targeting.First:
			for enemy in enemies_in_range:
				if enemy.progress_ratio > best_enemy.progress_ratio:
					best_enemy = enemy
		Targeting.Strong:
			for enemy in enemies_in_range:
				if enemy.health > best_enemy.health:
					best_enemy = enemy
	
	if best_enemy != null:
		var dist = best_enemy.global_position.distance_to(%offset.global_position)
		return best_enemy.predict_position(dist / base_projectile_speed)
	return null
