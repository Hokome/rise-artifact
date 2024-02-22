class_name GunSentry extends TargetingSentry

@export_category("Upgrade Stats")
@export var upgrade_damage_mult := 0.0
@export var upgrade_attack_speed_mult := 1.0

@export_category("Objects Refs")
@export var projectile: PackedScene
@export var trail: PackedScene

func fire(target: Vector2):
	can_fire = false
	var p: Projectile = projectile.instantiate()
	p.trail = trail.instantiate()
	p.speed = base_projectile_speed
	p.damage = get_damage()
	p.max_distance = base_projectile_lifetime
	
	var map = get_parent().get_parent()
	map.add_child(p.trail)
	map.add_child(p)
	
	var offset = %offset.global_position
	
	p.trail.add_point(offset)
	p.trail.add_point(offset)
	
	p.global_position = offset
	p.direction = (target - offset).normalized()
	p.look_at(target)
	
	$attack_cooldown.wait_time = get_attack_cooldown()
	$attack_cooldown.start()

func get_damage() -> int:
	var ratio = 1 + upgrade_damage_mult * upgrades
	return ceili(base_attack_damage * ratio)
func get_attack_cooldown() -> float:
	var ratio = 1.0
	for i in upgrades:
		ratio *= upgrade_attack_speed_mult
	return base_attack_cooldown * ratio
