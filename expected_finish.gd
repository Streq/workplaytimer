extends TimeLabel
tool

var remainder: TimeLabel
var work_timer: TimeLabel
var work_goal: TimeLabel
var now: TimeLabel

func initialize():
	if Engine.editor_hint:
		return
	work_goal.connect("updated", self, "update_time")
	now.connect("updated", self, "update_time")
	
func update_time():
	set_msec(now.msec + remainder.msec)
	set_text(Chronos.mil_to_text_time_hhmmssd(msec))
