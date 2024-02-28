extends VBoxContainer
signal activity_hover(activity, time)


const PROGRESS = preload("res://graph/progress.tscn")

onready var activities = $"%activities"
onready var dead_space = $"%dead_space"
onready var date_label = $"%date_label"

var total_progress = 0
var total_time = 0
func add_activity(activity: String, progress: int):
	var progress_node = PROGRESS.instance()
	progress_node.initialize(activity, progress)
	activities.add_child(progress_node)
	total_progress += progress
	activities.size_flags_stretch_ratio = total_progress
	progress_node.connect("hover",self,"_on_hover")
	update_display()
	return progress_node

func set_total_time(time:int):
	total_time = time

func set_date(date: String):
	date_label.text = date

func _on_hover(activity, progress):
	emit_signal("activity_hover", activity, progress)

func update_display():
	var remainder = MathUtils.maxi(0, total_time-total_progress)
	dead_space.size_flags_stretch_ratio = remainder
