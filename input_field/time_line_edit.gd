extends LineEdit
tool
signal msec_updated(msec)

const Chronos = preload("res://utils/Chronos.gd")

var msec = 0 setget set_msec

func set_msec(val):
	set_msec_internal(val)
	emit_signal("msec_updated", msec)
	
func set_msec_internal(val):
	msec = val
	if !is_inside_tree():
		return
	render_text()

export var update_on_edit := false

func _ready():
	connect("text_entered",self,"_on_text_entered")
	if update_on_edit:
		connect("text_changed",self,"_on_text_changed")
	connect("focus_exited",self,"update_msec")
	render_text()

func _on_text_entered(new_text):
	set_msec_string(new_text)
func update_msec():
	set_msec_string(text)
func _on_text_changed(new_text):
	set_msec_string(new_text)

func set_msec_string(text : String):
	set_msec(Chronos.hhmmssd_to_mil(text))

func render_text():
	text = text if !is_visible_in_tree() else Chronos.mil_to_text_interval_hhmmss(msec)
	
