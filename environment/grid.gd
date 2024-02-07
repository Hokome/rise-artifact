class_name GameGrid extends Node2D

@export var color: Color = Color.WHITE
@export var cell_size: float = 64

@onready var half_cell: float = cell_size * 0.5

func snap(raw_position: Vector2) -> Vector2:
	var xmod := fposmod(raw_position.x, cell_size)
	var ymod := fposmod(raw_position.y, cell_size)
	
	if abs(xmod) > half_cell:
		raw_position.x += cell_size - xmod
	else:
		raw_position.x -= xmod
	
	if abs(ymod) > half_cell:
		raw_position.y += cell_size - ymod
	else:
		raw_position.y -= ymod
	
	return raw_position

func global_to_grid(raw_position: Vector2) -> Vector2i:
	var snapped_position = snap(raw_position) - position
	return snapped_position / cell_size

func grid_to_local(grid_position: Vector2i) -> Vector2:
	return grid_position * cell_size

#func _process(_delta):
	#var camera : Camera2D = $"../editor_camera"
	#position = snap(camera.position)
	#scale = (get_viewport().size as Vector2) / camera.zoom
	#scale.x = scale.y
