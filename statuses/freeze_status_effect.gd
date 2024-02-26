extends EnemyStatusEffect

const DECAY := 1
const FREEZE_PENALTY := 0.98

func _on_tick_timeout():
	intensity -= DECAY

func _on_intensity_changed(value: int):
	target.speed_penalty = pow(FREEZE_PENALTY, value)

func on_remove():
	target.speed_penalty = 1.0
