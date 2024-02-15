class_name RoundGenerator extends Resource

@export var enemy_pool: Array[EnemyWrapper]
@export var budgets: Array[float]
@export var max_budget_noise: float

func generate() -> Array[Round]:
	var patterns: Array[WavePattern] = []
	for p in WavePattern.wave_patterns:
		if is_pattern_possible(p):
			patterns.append(p)
	
	var rounds: Array[Round] = []
	for budget in budgets:
		rounds.append(generate_round(budget + randf_range(-max_budget_noise, max_budget_noise), patterns))
	
	return rounds

func generate_round(budget: float, patterns: Array[WavePattern]) -> Round:
	var best_enemies: Array[EnemyWrapper] = []
	var best_pattern: WavePattern
	var best_distance: float = INF
	for p in patterns:
		var enemies_test: Array[EnemyWrapper] = []
		for req in p.sub_waves:
			enemies_test.append(select_enemy(budget, req))
		var dist = absf(budget - p.get_cost(enemies_test))
		if dist < best_distance:
			best_enemies = enemies_test
			best_distance = dist
			best_pattern = p
	
	var waves := best_pattern.generate_waves(best_enemies)
	var gen_round = Round.new()
	gen_round.waves = waves
	return gen_round

func select_enemy(allocated_budget: float, requirement: EnemyRequirement) -> EnemyWrapper:
	var candidates: Array[EnemyWrapper] = []

	for e in enemy_pool:
		if requirement.meets_requirements(e):
			candidates.append(e)
	
	var best_distance := INF
	var best_candidate: EnemyWrapper
	for c in candidates:
		var dist = absf(allocated_budget - requirement.get_budget(c))
		if dist < best_distance:
			best_candidate = c
			best_distance = dist
	
	return best_candidate

func is_pattern_possible(pattern: WavePattern) -> bool:
	for sw in pattern.sub_waves:
		if !fits_requirement(sw):
			return false
	return true

func fits_requirement(requirement: EnemyRequirement) -> bool:
	for e in enemy_pool:
		if requirement.meets_requirements(e):
			return true
	return false
