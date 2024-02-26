class_name Sentry extends Building

@export_category("Base Stats")
@export var base_attack_cooldown: float
@export var base_attack_damage: int
@export var base_attack_range: float
@export var base_aspect_intensity: int
#May be in seconds or in pixels depending on the projectile type
@export var base_projectile_lifetime: float = 6000

var aspect: Aspect
var can_fire: bool = true
var enemies_in_range: Array[Enemy] = []

func _ready():
	var range_hitbox = $range/detect.shape as CircleShape2D
	range_hitbox.radius = base_attack_range
	var range_circle = $range_circle as Sprite2D
	range_circle.scale = Vector2.ONE * base_attack_range / 200.0
	
	var timer = $attack_cooldown
	timer.wait_time = get_attack_cooldown()
	timer.timeout.connect(cooldown_ended)
	
	var range_area = $range as Area2D
	range_area.area_entered.connect(_on_range_area_entered)
	range_area.area_exited.connect(_on_range_area_exited)
	
	connect_mouse()

func cooldown_ended():
	can_fire = true

func get_damage() -> int:
	return base_attack_damage + (upgrade_behaviour.flat_damage * upgrades)
func get_attack_cooldown() -> float:
	return base_attack_cooldown * pow(upgrade_behaviour.attack_speed_mult, upgrades)

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
	
func on_hover(value: bool):
	if selected:
		return
	$range_circle.visible = value

func on_select(value: bool):
	if value:
		$range_circle.visible = true
	elif !hovered:
		$range_circle.visible = false
