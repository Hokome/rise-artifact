class_name BuildingUI extends ColorRect

var self_hovered := false

var selection: Building:
	set(value):
		if selection == value:
			return
		if selection != null and selection.update_description.is_connected(update_ui):
			selection.update_description.disconnect(update_ui)
			selection.selected = false
		selection = value
		if value == null:
			update_ui()
			return
		if !selection.update_description.is_connected(update_ui):
			selection.update_description.connect(update_ui)
		selection.selected = true
		update_ui()


var hover: Building:
	set(value):
		if hover == value:
			return
		if selection == null and hover != null and hover.update_description.is_connected(update_ui):
			hover.update_description.disconnect(update_ui)
		hover = value
		if selection == null:
			if value == null:
				update_ui()
				return
			if !hover.update_description.is_connected(update_ui):
				update_ui()
				hover.update_description.connect(update_ui)

func _input(event):
	if self_hovered:
		return
	if event is InputEventMouseButton:
		if !event.is_pressed():
			return
		if event.button_index == MOUSE_BUTTON_LEFT:
			selection = hover

func update_ui():
	var building: Building
	if selection != null:
		building = selection
	elif hover != null:
		building = hover
	else:
		visible = false
		return
	
	visible = true
	$margin/content/name.text = building.display_name
	$margin/content/description.text = building.description
	$margin/content/lower/targeting.text = building.get_targeting_text()
	$margin/content/lower/upgrades.text = "LV " + str(building.upgrades)

func building_hover_on(building: Building):
	hover = building

func building_hover_off(building: Building):
	if hover == building:
		hover = null

func _on_targeting_pressed():
	selection.cycle_targeting()

func _on_mouse_entered():
	self_hovered = true

func _on_mouse_exited():
	self_hovered = false
