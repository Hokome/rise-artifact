class_name StatusWrapper extends Resource

@export var scene: PackedScene
@export var unique_name: StringName
@export var display_name: String

@export_multiline var description: String

func apply(enemy: Enemy, status_intensity: int):
	var node := enemy.get_node_or_null(str(unique_name))
	if node == null:
		var st: EnemyStatusEffect = scene.instantiate()
		st.apply(enemy)
		st.intensity = status_intensity
	else:
		node.intensity += status_intensity
