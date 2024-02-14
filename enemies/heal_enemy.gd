extends Enemy

@export var heal_amount: int
@export var heal_cooldown: float

func _ready():
	var timer = Timer.new()
	timer.wait_time = heal_cooldown
	timer.timeout.connect(heal_allies)
	timer.autostart = true
	add_child(timer)

func heal_allies():
	var cast = $cast
	cast.force_shapecast_update()
	var result = cast.collision_result
	for col: Dictionary in result:
		var parent = col.collider.get_parent()
		if parent is Enemy:
			parent.heal(heal_amount)
