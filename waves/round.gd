class_name Round extends Resource

static var rounds: Array[Round] = []
static var initialized := false

@export var cost: float
@export var waves: Array[Wave] = []

static func initialize_rounds():
	if initialized:
		return
	initialized = true
	var paths := get_all_file_paths("res://waves/rounds/")
	rounds.resize(paths.size())
	for path_index in paths.size():
		rounds[path_index] = load(paths[path_index])

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
