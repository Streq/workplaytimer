extends VBoxContainer
signal display_activities(activities)

const ITEM = preload("res://graph/activity_item.tscn")
var items = []

func cleanup():
	for item in items:
		item.queue_free()
	items = []

func register_activity(activity, color):
	var item = ITEM.instance()
	add_child(item)
	item.set_color_no_signal(color)
	item.set_label_no_signal(activity)
	item.connect("single_updated", self, "update_display")
	item.connect("show_updated", self, "update_display")
	items.append(item)
func update_display():
	var activities_to_show : Array
		
	var to_solo = []
	var to_show = []
	for item in items:
		if item.single:
			to_solo.append(item.label)
		if item.show:
			to_show.append(item.label)
	
	if to_solo:
		activities_to_show = to_solo
	else:
		activities_to_show = to_show
	
	emit_signal("display_activities", activities_to_show)

func get_selected():
	var ret = []
	for item in items:
		if item.single:
			ret.append(item.label)
	return ret	
