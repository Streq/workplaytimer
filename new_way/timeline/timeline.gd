extends Reference
class_name Timeline

var activities = {}
var _new_timer_ref = funcref(self, "_new_timer")
var _current_timer := LogBasedTimer.new()
func _new_timer():
	return LogBasedTimer.new()

func start(activity: String):
	var now := TimeUtils.now_mil()
	start_at(activity, now)
func start_at(activity: String, at: int):
	var timer : LogBasedTimer = MapUtils.compute_if_absent(activities, activity, _new_timer_ref)
	
	_current_timer.stop_at(at)
	timer.start_at(at)
	
	_current_timer = timer

func stop():
	var now := TimeUtils.now_mil()
	stop_at(now)
func stop_at(at: int):
	_current_timer.stop_at(at)


func update_look():
	pass
