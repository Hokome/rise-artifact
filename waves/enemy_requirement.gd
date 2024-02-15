class_name EnemyRequirement extends Resource

@export var base_cost: float
@export var offset: float
@export var count: int
@export var spacing: float
@export var requirements: Array[String]

func meets_requirements(enemy: EnemyWrapper) -> bool:
	for r in requirements:
		if !enemy.tags.has(r):
			return false
	return true

func get_budget(enemy: EnemyWrapper) -> float:
	return base_cost * enemy.cost_modifier

func to_wave(enemy: EnemyWrapper, delay: float) -> Wave:
	var wave = Wave.new()
	wave.enemy = enemy
	wave.delay = delay + offset
	wave.count = count
	wave.spacing = spacing
	return wave
