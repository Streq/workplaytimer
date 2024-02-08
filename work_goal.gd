extends TimeLabel


func _ready() -> void:
	if Engine.editor_hint:
		return
#	._ready()
	label.connect("focus_exited",self,"_focus_out")
	_on_text_changed()
	load_()

func _focus_out():
	render_text()
	save()
