extends TimeLabel
tool

var work_goal: TimeLabel
var work_timer : TimeLabel

func initialize() -> void:
	if Engine.editor_hint:
		return
	work_timer.connect("updated", self, "update_text")
	work_goal.connect("updated", self, "update_text")

func update_text():
	var dif = work_goal.msec - work_timer.msec
	set_msec(dif)
	render_text()
