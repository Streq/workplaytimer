extends VBoxContainer

const PROGRESS = preload("res://graph/progress.tscn")

onready var activities = $"%activities"
onready var dead_space = $"%dead_space"
onready var date_label = $"%date_label"

var total_progress = 0

func add_activity(activity: String, progress: int):
	var progress_node = PROGRESS.instance()
	progress_node.initialize(activity, progress)
	activities.add_child(progress_node)
	total_progress += progress
	activities.size_flags_stretch_ratio = total_progress
	return progress_node
func set_total_time(time:int):
	var remainder = MathUtils.maxi(0, time-total_progress)
	dead_space.size_flags_stretch_ratio = remainder
func set_date(date: String):
	date_label.text = date
