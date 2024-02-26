extends AreaAttack

var status_effect: StatusWrapper
var intensity: int

func apply_effect(enemy: Enemy):
	enemy.damage(damage)
	status_effect.apply(enemy, intensity)
