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
		if value:
			modulate.a = 0.5
		else:
			modulate.a = 1
		preview = value


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


func _on_mouse_entered():
	if !preview:
		hover_on.emit(self)

func _on_mouse_exited():
	if !preview:
		hover_off.emit(self)
