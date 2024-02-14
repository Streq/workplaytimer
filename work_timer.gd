extends TimeLabel
tool


var last_start_msec := 0

func _process(_ignored_: float) -> void:
	if Engine.editor_hint:
		return
	var now = Global.now_msec()
	var delta = now - last_start_msec
	
	set_msec(msec + delta)
	
	if msec_before/1000!=msec/1000:
		save()
	
	last_start_msec = now
	render_text()

func _start():
	last_start_msec = Global.now_msec()


func _ready():
	if Engine.editor_hint:
		return
	load_()
		
