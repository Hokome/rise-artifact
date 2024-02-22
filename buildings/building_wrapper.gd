class_name BuildingWrapper extends Resource

@export var display_name: String = "Building"
@export_multiline var description: String = "Can be built with the help of cards"

@export var building_scene: PackedScene

func instantiate() -> Building:
	var scene = building_scene.instantiate()
	scene.wrapper = self
	return scene
