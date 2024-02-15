class_name WavePattern extends Resource

static var wave_patterns: Array[WavePattern] = []
static var initialized := false

@export var base_cost: float = 0
@export var sub_waves: Array[EnemyRequirement]

static func initialize_patterns():
	if initialized:
		return
	initialized = true
	var paths := get_all_file_paths("res://waves/patterns/")
	wave_patterns.resize(paths.size())
	for path_index in paths.size():
		wave_patterns[path_index] = load(paths[path_index])

static func get_all_file_paths(path: String) -> Array[String]:
	var file_paths: Array[String] = []
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var file_path = path + "/" + file_name
		if dir.current_is_dir():
			file_paths += get_all_file_paths(file_path)
		else:
			file_paths.append(file_path)
		file_name = dir.get_next()
	return file_paths

func generate_waves(enemies: Array[EnemyWrapper]) -> Array[Wave]:
	var waves: Array[Wave] = []
	for wave_index in sub_waves.size():
		waves.append(sub_waves[wave_index].to_wave(enemies[wave_index], 0))
	return waves

func get_cost(enemies: Array[EnemyWrapper]) -> float:
	var total := base_cost
	for wave_index in sub_waves.size():
		total += sub_waves[wave_index].get_budget(enemies[wave_index])
	return total
