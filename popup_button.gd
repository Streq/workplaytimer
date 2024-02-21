extends Button
onready var popup = $"%popup"

func _ready():
	connect("toggled", self, "_toggled")
	popup.connect("visibility_changed", self, "_on_popup_visibility_changed")
func _on_popup_visibility_changed():
	set_pressed_no_signal(popup.visible)
	
func _toggled(val):
	if val:
		popup.popup_centered()
	else:
		popup.visible = false
