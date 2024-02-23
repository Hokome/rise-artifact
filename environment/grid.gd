class_name GameGrid extends TileMap

const TERRAIN_SOURCE_ID: int = 0
const TERRAIN_LAYER: int = 0

@export var offset: Vector2i = Vector2i(10, 5)
@export var size: Vector2i = Vector2i(15, 10)

var buildings = []

func _ready():
	buildings.resize(size.x)
	for i in size.x:
		var array = []
		array.resize(size.y)
		array.fill(null)
		buildings[i] = array 

func add_building(building: Building, pos: Vector2i):
	building.reparent(self)
	building.position = map_to_local(pos)
	
	var building_ui: BuildingUI = $"../..".building_ui()
	
	building.hover_on.connect(building_ui.building_hover_on)
	building.hover_off.connect(building_ui.building_hover_off)
	building_ui.hover = building
	
	set_building_at(building, pos)
	
func in_bounds(pos: Vector2i) -> bool:
	pos += offset
	if pos.x < 0 or pos.x >= size.x:
		return false
	if pos.y < 0 or pos.y >= size.y:
		return false
	return true

func set_building_at(building: Building, pos: Vector2i):
	if !in_bounds(pos):
		return
	
	pos += offset
	buildings[pos.x][pos.y] = building

func get_building_at(pos: Vector2i) -> Building:
	if !in_bounds(pos):
		return null
	
	pos += offset
	return buildings[pos.x][pos.y]
