extends TextEdit
signal updated

var last_start_msec := 0
var accumulated_time_msec := 0
export var stopped := false

func _ready() -> void:
	set_stopped(stopped)
	render_text()
	connect("text_changed",self,"_on_text_changed")
func render_text():
	text = Global.to_text(accumulated_time_msec)
	emit_signal("updated")

func set_stopped(val):
	stopped = val
	if stopped:
		off()
	else:
		on()

func _process(delta: float) -> void:
	var now = Global.now_msec()
	var step = now - last_start_msec
	accumulated_time_msec += step
	last_start_msec = now
	render_text()

func switch():
	if stopped:
		on()
	else:
		off()

func on():
	stopped = false
	last_start_msec = Global.now_msec()
	set_process(true)
func off():
	stopped = true
	set_process(false)



	
func _on_text_changed():
	accumulated_time_msec = Global.from_text(text)
