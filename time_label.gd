extends TextEdit

var last_start_msec := 0
var accumulated_time_msec := 0
export var stopped := false

func _ready() -> void:
	set_stopped(stopped)
	render_text()
	connect("text_changed",self,"_on_text_changed")
func render_text():
	text = to_text(accumulated_time_msec)

func set_stopped(val):
	stopped = val
	if stopped:
		off()
	else:
		on()

func _process(delta: float) -> void:
	var now = now_msec()
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
	last_start_msec = now_msec()
	set_process(true)
func off():
	stopped = true
	set_process(false)


static func now_msec():
	return Time.get_ticks_msec()


static func to_text(msec: int)->String:
	var seconds := msec/1000
	var unit_hours = seconds/60/60
	var unit_minutes = (seconds/60)%60
	var unit_seconds = seconds%60
	var unit_dsec = msec%1000/100
	return "%02d:%02d:%02d.%01d" % [unit_hours, unit_minutes, unit_seconds, unit_dsec]

static func from_text(text:String):

	var vals = text.split(":")
	var secs_dsecs = vals[-1].split(".")

	var unit_hours = int(vals[0])
	var unit_minutes = int(vals[1])
	var unit_seconds = int(secs_dsecs[0])
	var unit_dsec = int(secs_dsecs[1])
	
	var msec = (
		unit_hours*60*60*1000 + 
		unit_minutes*60*1000 + 
		unit_seconds*1000 + 
		unit_dsec*100
	)
	return msec
	
func _on_text_changed():
	accumulated_time_msec = from_text(text)
