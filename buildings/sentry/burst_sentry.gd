extends GunSentry

@export var base_min_size := 10
@export var base_max_size := 200.0
@export var upgrade_size_mult := 0.2

func fire(target: Vector2):
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
	
	p.global_position = offset
	p.direction = (target - offset).normalized()
	p.look_at(target)
	
	$attack_cooldown.wait_time = get_attack_cooldown()
	$attack_cooldown.start()

func get_projectile_max_size() -> float:
	var ratio = 1 + upgrade_size_mult * upgrades
	return base_max_size * ratio
func get_projectile_min_size() -> float:
	var ratio = 1 + upgrade_size_mult * upgrades
	return base_min_size * ratio
