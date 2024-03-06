class_name DebugScript extends Node2D

var command_dictionary: Dictionary

func _ready():
	command_dictionary = {}
	add_to_dictionary(Command.new(), "print")
	add_to_dictionary(PowerCommand.new(), "power")
	add_to_dictionary(SkipCommand.new(), "skip")
	add_to_dictionary(HPCommand.new(), "hp")
	add_to_dictionary(MaxHPCommand.new(), "mhp")
	add_to_dictionary(CardCommand.new(), "card")

func add_to_dictionary(command: Command, key: StringName):
	command_dictionary[key] = command
	command.key = key
	command.context = self

func _input(event):
	if event is InputEventKey:
		if event.pressed and !event.is_echo():
			if event.keycode == KEY_F3:
				toggle_prompt()

func toggle_prompt():
	var prompt: LineEdit = $prompt
	prompt.visible = !prompt.visible
	if prompt.visible:
		prompt.grab_focus()
	prompt.clear()


func _on_prompt_text_submitted(new_text: String):
	var words = new_text.split(" ", false)
	if words.is_empty():
		return
	var command: Command = command_dictionary.get(words[0])
	if command == null:
		return
	words.remove_at(0)
	if command.can_execute(words):
		command.execute(words)
	toggle_prompt()
