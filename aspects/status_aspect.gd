class_name StatusAspect extends Aspect

@export var status_effect: StatusWrapper

func apply_to_enemy(enemy: Enemy, sentry: Building):
	status_effect.apply(enemy, sentry.base_aspect_intensity)

func modify_projectile(projectile: Projectile, intensity: int):
	projectile.modulate = color
	projectile.status_effect = status_effect
	projectile.status_intensity = intensity
