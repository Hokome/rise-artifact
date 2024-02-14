class_name BuildingUI extends ColorRect

var self_hovered := false

var selected: Building:
	set(value):
		if selected == value:
			return
		if selected != null and selected.update_description.is_connected(update_ui):
			selected.update_description.disconnect(update_ui)
		selected = value
		if value == null:
			update_ui()
			return
		if !selected.update_description.is_connected(update_ui):
			selected.update_description.connect(update_ui)
		update_ui()


var hovered: Building:
	set(value):
		if hovered == value:
			return
		if selected == null and hovered != null and hovered.update_description.is_connected(update_ui):
			hovered.update_description.disconnect(update_ui)
		hovered = value
		if selected == null:
			if value == null:
				update_ui()
				return
			if !hovered.update_description.is_connected(update_ui):
				update_ui()
				hovered.update_description.connect(update_ui)

func _input(event):
	if self_hovered:
		return
	if event is InputEventMouseButton:
		if !event.is_pressed():
			return
		if event.button_index == MOUSE_BUTTON_LEFT:
			selected = hovered

func update_ui():
	var building: Building
	if selected != null:
		building = selected
	elif hovered != null:
		building = hovered
	else:
		visible = false
		return
	
	visible = true
	$margin/content/name.text = building.display_name
	$margin/content/description.text = building.description
	$margin/content/lower/targeting.text = building.get_targeting_text()
	$margin/content/lower/upgrades.text = "LV " + str(building.upgrades)

func building_hover_on(building: Building):
	hovered = building

func building_hover_off(building: Building):
	if hovered == building:
		hovered = null

func _on_targeting_pressed():
	selected.cycle_targeting()

func _on_mouse_entered():
	self_hovered = true

func _on_mouse_exited():
	self_hovered = false
