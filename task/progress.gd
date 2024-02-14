extends ProgressBar


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("value_changed",self,"_value_changed")

func _value_changed(_new_value):
	if ratio == 1.0:
		theme = preload("complete_theme.tres")
	else:
		theme = preload("incomplete_theme.tres")
	
