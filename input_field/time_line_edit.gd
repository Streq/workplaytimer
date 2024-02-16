extends LineEdit
tool
signal msec_updated(msec)

var msec = 0 setget set_msec

func set_msec(val):
	set_msec_internal(val)
	emit_signal("msec_updated", msec)
	
func set_msec_internal(val):
	msec = val
	if !is_inside_tree():
		return
	render_text()



func _ready():
	connect("text_entered",self,"_on_text_entered")
	connect("text_changed",self,"_on_text_changed")
	connect("focus_exited",self,"_on_focus_exited")
	render_text()

func _on_text_entered(new_text):
	set_msec(Global.from_text(new_text))
func _on_focus_exited():
	set_msec(Global.from_text(text))
func _on_text_changed(new_text):
	msec = Global.from_text(new_text)
	emit_signal("msec_updated", msec)
	
func render_text():
	text = Global.to_text_no_sub_sec(msec)
	
