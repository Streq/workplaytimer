extends PanelContainer
signal join(selected, new_name)
signal display_activities(activities)
onready var name_change = $"%name_change"
onready var activities_node = $"%activities"

func _ready():
	name_change.connect("submit", self, "_on_name_change_submit")
	activities_node.connect("display_activities", self, "_display_activities")

func _display_activities(activities):
	emit_signal("display_activities", activities)
	
func _on_name_change_submit(new_name):
	var selected = activities_node.get_selected()
	emit_signal("join", selected, new_name)

func cleanup():
	activities_node.cleanup()

func register_activity(activity, color):
	activities_node.register_activity(activity, color)
