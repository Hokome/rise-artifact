extends ColorRect

func set_cost(value: int):
	%cost.text = str(value)

func set_title(value: String):
	%title.text = value

func set_illustration(value: Texture):
	%illustration.texture = value

func get_description_label() -> RichTextLabel: return %description
