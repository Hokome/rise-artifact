extends AreaAttack

var status_effect: PackedScene
var intensity: int

func apply_effect(enemy: Enemy):
	enemy.damage(damage)
	EnemyStatusEffect.apply_status(enemy, status_effect, intensity)
