extends TimeLabel
tool

func _ready():
	add_to_group("now_label")

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		return
	update_time()

func update_time():
	set_msec(Chronos.local_now_mil())
	set_text(Chronos.mil_to_text_time_hhmmssd(msec))

