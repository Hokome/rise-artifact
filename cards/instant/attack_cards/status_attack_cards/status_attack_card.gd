extends AttackCard

@export var status_effect: StatusWrapper
@export var intensity: int

func use_attack(game: Game, position: Vector2):
	var attack: AreaAttack = attack_scene.instantiate()
	var shape = CircleShape2D.new()
	shape.radius = radius
	attack.shape = shape
	attack.damage = damage
	attack.status_effect = status_effect
	attack.intensity = intensity
	
	game.map.add_child(attack)
	attack.position = position
	
	attack.execute()

func get_formatter() -> Dictionary: return {"damage":damage, "intensity":intensity, "effect":status_effect.display_name}

func get_default_description() -> String: return "Deal {damage} damage and apply {intensity} [color=[cyan]]{effect}[/color]"
