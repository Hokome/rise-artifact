extends AttackCard

@export var status_effect: PackedScene
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
