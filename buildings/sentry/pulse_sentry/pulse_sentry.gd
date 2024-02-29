extends StaticSentry

@export var base_min_size := 10
@export var base_max_size := 200.0

@export_category("Objects Refs")
@export var projectile: PackedScene

func fire():
	can_fire = false
	var p: Projectile = projectile.instantiate()
	
	p.damage = get_damage()
	p.min_size = base_min_size
	p.max_size = base_max_size
	p.lifetime = base_projectile_lifetime
	
	var map = get_parent().get_parent()
	map.add_child(p)
	
	var offset = %offset.global_position
	
	p.global_position = offset
	
	if aspect != null:
		aspect.modify_projectile(p, base_aspect_intensity)
	
	$attack_cooldown.wait_time = get_attack_cooldown()
	$attack_cooldown.start()
