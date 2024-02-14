extends Building

@export var base_attack_cooldown: float
@export var base_attack_damage: int
@export var base_attack_range: float

@export var upgrade_damage_mult := 0.0
@export var upgrade_attack_speed_mult := 1.0

var can_fire: bool = true
var enemies_in_range: Array[Enemy] = []

func fire(target: Enemy):
	can_fire = false
	target.damage(get_damage())
	$attack_cooldown.wait_time = get_attack_cooldown()
	$attack_cooldown.start()

func cooldown_ended():
	can_fire = true

func get_damage() -> int:
	var ratio = 1 + upgrade_damage_mult * upgrades
	return ceili(base_attack_damage * ratio)
func get_attack_cooldown() -> float:
	var ratio = 1.0
	for i in upgrades:
		ratio *= upgrade_attack_speed_mult
	return base_attack_cooldown * ratio
	

func _ready():
	var range_hitbox = $range/circle.shape as CircleShape2D
	range_hitbox.radius = base_attack_range
	
	var timer = $attack_cooldown
	timer.wait_time = get_attack_cooldown()
	timer.timeout.connect(cooldown_ended)

func _process(_delta):
	if Game.paused or preview:
		return
	
	var target := get_target()
	if target != null:
		$gun.look_at(target.global_position)
		if can_fire:
			fire(target)

func _on_range_area_entered(area):
	var node = area.get_parent()
	if node is Enemy:
		enemies_in_range.append(node)

func _on_range_area_exited(area):
	var node = area.get_parent()
	if node is Enemy:
		enemy_out_of_range(node)

func enemy_out_of_range(enemy: Enemy):
	enemies_in_range.erase(enemy)

func get_target() -> Enemy:
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
