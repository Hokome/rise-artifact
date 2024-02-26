class_name Aspect extends Resource

@export var display_name: String
@export var color: Color

func modify_trail(trail: Line2D):
	trail.default_color = color

func modify_projectile(projectile: Projectile, _intensity: int):
	projectile.modulate = color

func apply_to_enemy(_enemy: Enemy, _sentry: Building):
	pass

func modify_sentry(sentry: Sentry):
	sentry.aspect = self
	sentry.modulate = color
