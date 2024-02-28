extends VBoxContainer


onready var caret_size_node = $"%caret_size"

onready var work_graph = $"%work_graph"
onready var hover_activity_name = $"%hover_activity_name"
onready var hover_activity_progress = $"%hover_activity_progress"
onready var activities = $"%activities"


func _ready():
	work_graph.connect("activity_hover", self, "_on_activity_hover")
	
	caret_size_node.connect("text_entered", self ,"_on_hours_on_window_entered")
	
	activities.connect("display_activities", work_graph, "filter_activities")
	refresh()
func _on_hours_on_window_entered(text):
#	work_graph.refresh()
	pass

func _on_activity_hover(activity: String, millis: int):
	hover_activity_name.text = activity
	hover_activity_progress.text = TimeUtils.mil_to_text_interval_hhmmssd(millis)

func refresh():
	activities.cleanup()
	
	work_graph.refresh()
	var activity_color_map = work_graph.colors
	for activity in activity_color_map:
		var color = activity_color_map[activity]
		activities.register_activity(activity, color)
