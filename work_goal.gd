extends TextEdit
signal updated
var goal_msecs = 0

func _ready() -> void:
	connect("text_changed",self,"_on_text_changed")
	_on_text_changed()

func _on_text_changed():
	goal_msecs = Global.from_text(text)
	emit_signal("updated")
