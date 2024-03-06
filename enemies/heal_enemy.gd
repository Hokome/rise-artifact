extends Enemy

@export var heal_amount: int
@export var heal_cooldown: float

func _ready():
	var timer = time_manager.create_battle_timer(heal_cooldown, false)
	add_child(timer)
	timer.timeout.connect(heal_allies)

func heal_allies():
	var cast = $cast
	cast.force_shapecast_update()
	var result = cast.collision_result
	for col: Dictionary in result:
		var parent = col.collider.get_parent()
		if parent is Enemy:
			parent.heal(heal_amount)
