extends TimeLabel
tool

var last_start_msec := 0

func _on_msec_changed():
	render_text()

func time_step(delta: int) -> void:
	if Engine.editor_hint:
		return
	set_msec(msec + delta)
	render_text()


func _ready():
	if Engine.editor_hint:
		return
	load_()
