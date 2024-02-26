class_name Building extends StaticBody2D

enum Targeting {First, Strong}

@export var upgrade_behaviour: UpgradeBehaviour

var wrapper: BuildingWrapper

var targeting := Targeting.First
var upgrades := 0:
	set(value):
		upgrades = value
		update_description.emit()

signal update_description()
signal hover_on(building: Building)
signal hover_off(building: Building)

@onready var preview := true:
	set(value):
		modulate.a = 0.5 if value else 1.0
		preview = value
		on_preview(value)
var selected: bool:
	set(value):
		selected = value
		on_select(value)
var hovered: bool:
	set(value):
		hovered = value
		on_hover(value)

func cycle_targeting():
	if targeting == Targeting.First:
		targeting = Targeting.Strong
	else:
		targeting = Targeting.First
	update_description.emit()
func get_targeting_text() -> String:
	match targeting:
		Targeting.First:
			return "First"
		Targeting.Strong:
			return "Strong"
	return ""

func on_preview(_value: bool):
	pass

func on_select(_value: bool):
	pass

func on_hover(_value: bool):
	pass

func connect_mouse():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _ready():
	connect_mouse()

func _on_mouse_entered():
	if !preview:
		hover_on.emit(self)
		hovered = true

func _on_mouse_exited():
	if !preview:
		hover_off.emit(self)
		hovered = false
