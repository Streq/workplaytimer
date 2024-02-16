extends ProgressBar

export var focus := false setget set_focus

func _ready():
	connect("value_changed",self,"_value_changed")
	connect("changed", self, "_changed")
func _value_changed(_new_value):
	update_look()
func _changed():
	pass
func set_focus(val):
	focus = val
	update_look()


func update_look():
	if focus:
		theme_type_variation = "ProgressBar_focus"
	else:
		theme_type_variation = ""
