extends Path2D

var preview_node: PathFollow2D

func _ready():
	preview_node = PathFollow2D.new()
	add_child(preview_node)

func get_prediction(progress: float) -> Vector2:
	preview_node.progress = progress
	return preview_node.global_position
