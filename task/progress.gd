extends ProgressBar


func _ready():
	connect("value_changed",self,"_value_changed")
	connect("changed", self, "_changed")
func _value_changed(_new_value):
	if ratio == 1.0:
		theme = preload("complete_theme.tres")
	else:
		theme = preload("incomplete_theme.tres")
func _changed():
	pass
