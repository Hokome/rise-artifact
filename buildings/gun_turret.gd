extends Building

@export var base_attack_cooldown: float
@export var base_attack_damage: int
@export var base_attack_range: float

var can_fire: bool = true
var enemies_in_range: Array[Enemy] = []


func fire(target: Enemy):
	can_fire = false
	target.damage(base_attack_damage)
	$attack_cooldown.start()

func cooldown_ended():
	can_fire = true

func _ready():
	var range_hitbox = $range/circle.shape as CircleShape2D
	range_hitbox.radius = base_attack_range
	
	var timer = $attack_cooldown
	timer.wait_time = base_attack_cooldown
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
	var first_enemy := enemies_in_range[0]
	for enemy in enemies_in_range:
		if enemy.progress_ratio > first_enemy.progress_ratio:
			first_enemy = enemy
	
	return first_enemy
