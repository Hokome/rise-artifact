class_name RoundGenerator extends Resource

@export var budgets: Array[float]
@export var max_budget_noise: float
@export var max_cost_noise: float

func generate() -> Array[Round]:
	var rounds: Array[Round] = []
	for budget in budgets:
		var noise := randf_range(-max_budget_noise, max_budget_noise)
		rounds.append(select_round(budget + noise))
	return rounds

func select_round(budget: float) -> Round:
	var best_round: Round
	var best_distance: float = INF
	
	for r in Round.rounds:
		var cost_noise = randf_range(-max_cost_noise, max_cost_noise)
		var dist = absf(budget - r.cost + cost_noise)
		if dist < best_distance:
			best_distance = dist
			best_round = r
	
	return best_round
