extends Card

@export var attack_scene: PackedScene
@export var damage := 0
@export var radius := 1.0

func play(game: Game):
	var selected_pos = await game.player_controller().select_range(radius)
	if selected_pos == null:
		return
	
	var attack: AreaAttack = attack_scene.instantiate()
	var shape = CircleShape2D.new()
	shape.radius = radius
	attack.shape = shape
	attack.damage = damage
	
	game.map.add_child(attack)
	attack.position = selected_pos
	
	attack.execute()
	
	consume_power(game)
	discard(game)

func set_description(rtl: RichTextLabel):
	rtl.append_text("Deal ")
	rtl.append_text(str(damage))
	rtl.append_text(" damage in a ")
	rtl.append_text(str(radius))
	rtl.append_text("cm radius")
