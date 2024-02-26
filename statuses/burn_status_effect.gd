extends EnemyStatusEffect

const DECAY := 10

func _on_tick_timeout():
	target.damage(intensity)
	intensity -= DECAY
