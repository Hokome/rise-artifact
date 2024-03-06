class_name TargetingSentry extends Sentry

func _process(_delta):
	if time_manager.get_battle_paused() or preview:
		return
	
	var target = get_target()
	if target != null:
		$gun.look_at(get_target_pos(target))
		if can_fire:
			fire(target)

func fire(_target: Enemy):
	pass

func get_target():
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
	return best_enemy

func get_target_pos(enemy, projectile_speed = null):
	if enemy != null:
		if projectile_speed == null:
			return enemy.global_position
		var dist = enemy.global_position.distance_to(%offset.global_position)
		return enemy.predict_position(dist / projectile_speed)
	return null
