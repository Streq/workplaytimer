extends TextEdit

export var remainder_path : NodePath
onready var remainder = get_node(remainder_path)


func _process(delta: float) -> void:
	var msecs_now = Global.from_text(Time.get_time_string_from_system())
	var msecs_remaining = msecs_now + remainder.msec
	text = Global.to_text_no_secs(msecs_remaining)
