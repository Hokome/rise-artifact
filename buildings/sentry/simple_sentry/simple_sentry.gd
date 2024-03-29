class_name GunSentry extends TargetingSentry

@export_category("Objects Refs")
@export var trail: PackedScene

func fire(target: Enemy):
	can_fire = false
	var t: Line2D = trail.instantiate()
	
	var offset = %offset.global_position
	
	t.lifetime = base_projectile_lifetime
	
	var map = get_parent().get_parent()
	
	var contact_point = get_contact_point(get_target_pos(target))
	t.add_point(offset - contact_point)
	t.add_point(Vector2.ZERO)
	
	map.add_child(t)
	t.global_position = contact_point
	
	target.damage(get_damage())
	if aspect != null:
		aspect.apply_to_enemy(target, self)
		aspect.modify_trail(t)
	
	$attack_cooldown.wait_time = get_attack_cooldown()
	$attack_cooldown.start()

func get_contact_point(target: Vector2):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, target,
		collision_mask)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var result = space_state.intersect_ray(query)
	return result.position
