extends TargetingSentry

@export var base_projectile_speed: float = 100.0
@export var base_min_size := 10
@export var base_max_size := 200.0

@export_category("Objects Refs")
@export var projectile: PackedScene

func fire(target: Enemy):
	can_fire = false
	var p: Projectile = projectile.instantiate()
	p.speed = base_projectile_speed
	p.damage = get_damage()
	p.min_size = get_projectile_min_size()
	p.max_size = get_projectile_max_size()
	p.lifetime = base_projectile_lifetime
	
	var map = get_parent().get_parent()
	map.add_child(p)
	
	var offset = %offset.global_position
	
	var target_pos = get_target_pos(target, base_projectile_speed)
	
	p.global_position = offset
	p.direction = (target_pos - offset).normalized()
	p.look_at(target_pos)
	
	if aspect != null:
		aspect.modify_projectile(p, base_aspect_intensity)
	
	$attack_cooldown.wait_time = get_attack_cooldown()
	$attack_cooldown.start()

func get_projectile_max_size() -> float:
	return base_max_size
func get_projectile_min_size() -> float:
	return base_min_size
