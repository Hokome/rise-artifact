class_name Command extends RefCounted

var key: StringName
var context: Node2D

func can_execute(_args) -> bool: return true

func min_args(args, count: int) -> bool: return args.size() >= count

func execute(args):
	var rest: PackedStringArray = args
	print(" ".join(rest))

func game() -> Game: return context.get_parent()
