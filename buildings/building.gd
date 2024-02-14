class_name Building extends StaticBody2D

enum Targeting {First, Strong}

@export var display_name: String = "Building"
@export_multiline var description: String = "Can be built with the help of cards"

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

func _on_mouse_entered():
	if !preview:
		hover_on.emit(self)
		on_hover(true)

func _on_mouse_exited():
	if !preview:
		hover_off.emit(self)
		on_hover(false)
