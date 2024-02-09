extends TimeLabel
tool

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		return
	update_time()

func update_time():
	var now_sec = Global.from_text(Time.get_time_string_from_system())
	#for subsecond precision, sucks I know
	var now_sub_msec = int(Time.get_unix_time_from_system()*1000.0)%1000
	set_msec(now_sec + now_sub_msec)
	set_text(Global.to_text_wrap_hours(msec))

