extends TimeLabel
tool

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		return
	update_time()

func update_time():
	set_msec(Global.now_msec())
	set_text(Global.to_text_wrap_hours(msec))

