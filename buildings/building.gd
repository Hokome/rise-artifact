class_name Building extends Node2D

@onready var preview := true:
	set(value):
		if value:
			modulate.a = 0.5
		else:
			modulate.a = 1
		preview = value
