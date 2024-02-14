class_name Enemy extends PathFollow2D

const GROUP: StringName = "enemies"
const DAMAGE_NUMBER_OFFSET: int = 100
const DAMAGE_NUMBER_TIME: float = 0.6

static var damage_number_scene: PackedScene = load("res://vfx/damage_number.tscn")
static var damage_number_green: LabelSettings = load("res://vfx/green_damage.tres")

signal death(Enemy)
signal reached_end(int)

@export var base_speed: float = 600
@export var max_health: int = 100
@export var player_damage: int = 1

@onready var health: int = max_health:
	set(value):
		health = min(max_health, value)
		if value <= 0:
			kill()

func _process(delta):
	progress += get_speed() * delta
	
	if progress_ratio == 1:
		damage_player()

func damage(amount: int):
	health -= amount
	display_damage(amount)

func heal(amount: int):
	health += amount
	display_damage(amount, damage_number_green)

func get_speed() -> float:
	return base_speed

func display_damage(amount: int, label_settings: LabelSettings = null):
	var damage_number: Node2D = damage_number_scene.instantiate()
	var text = damage_number.get_node("text") as Label
	if label_settings != null:
		text.label_settings = label_settings
	text.text = str(amount)
	
	get_tree().root.get_child(0).add_child(damage_number)
	damage_number.global_position = global_position
	
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(damage_number, "global_position", global_position + Vector2.UP * DAMAGE_NUMBER_OFFSET, 1)

func predict_position(time: float) -> Vector2:
	return get_parent().get_prediction(progress + time * get_speed())

func kill():
	remove()

func damage_player():
	reached_end.emit(player_damage)
	remove()

func remove():
	death.emit(self)
	queue_free()
