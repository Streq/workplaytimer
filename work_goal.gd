extends TimeLabel

func _ready() -> void:
	if Engine.editor_hint:
		return
#	._ready()
	connect("focus_exited",self,"_focus_out")
	_on_text_changed()

func _focus_out():
	set_text(Global.to_text(msec))
	render_text()
