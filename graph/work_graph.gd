extends Control
signal activity_hover(activity, progress)

var PROGRESS = preload("res://graph/progress.tscn")
var DATE = preload("res://graph/date.tscn")
onready var days = $"%days"
var colors = {}

var dates = {}
var activity_nodes = {}


onready var days_node = $"%days"


func refresh():
	cleanup()
	
	var history : History.Log = History.retrieve_progress_history()
	
	if history.is_empty():
		return
	
	populate(history)

func populate(history: History.Log):
	var used_dates = history.get_dates()
	var first_date = used_dates[0]
	var last_date = used_dates[used_dates.size()-1]
	var all_dates = get_all_dates_between(first_date, last_date)
	var max_progress = history.get_max_progress()

	for date in all_dates:
		var date_node = DATE.instance()
		date_node.connect("activity_hover",self,"_on_activity_hover")
		dates[date] = date_node
		days_node.add_child(date_node)
		date_node.set_date(date)
		date_node.set_total_time(max_progress)
		
	for date in used_dates:
		var map = history.get_activity_progress_map(date)
		var date_node = dates[date]
		for activity in map:
			var progress_node = date_node.add_activity(activity, map[activity])
			var nodes = MapUtils.put_if_absent(activity_nodes, activity, [])
			nodes.append(progress_node)

	for activity in activity_nodes:
		var color = get_activity_color(activity)
		
		for node in activity_nodes[activity]:
			node.modulate = color

func cleanup():
	for date_node in dates.values():
		date_node.queue_free()
	dates = {}
	activity_nodes = {}

func generate_color():
	return Color(randi() | 0xff)
var color_generator = funcref(self, "generate_color") 

func get_activity_color(activity):
	return MapUtils.compute_if_absent(colors, activity, color_generator)

static func get_all_dates_between(first_date:String, last_date:String) -> PoolStringArray:
	var days_from: int = Calendar.string_to_days(first_date)
	var days_to: int = Calendar.string_to_days(last_date)+1
	var ret := PoolStringArray()
	var total_days: int = days_to-days_from
	ret.resize(total_days)
	for i in total_days:
		var days: int = days_from+i
		var date: String = Calendar.days_to_string(days)
		ret[i] = date
	return ret
	
func _on_activity_hover(activity:String, progress:int):
	emit_signal("activity_hover", activity, progress)

func filter_activities(activities: Array):
	# hide all
	for activity in activity_nodes:
		var nodes = activity_nodes[activity]
		for node in nodes:
			node.modulate = Color.transparent
	# show only selected
	for activity in activities:
		var nodes = activity_nodes[activity]
		var color = get_activity_color(activity)
		for node in nodes:
			node.modulate = color
			node.get_parent().move_child(node, node.get_parent().get_child_count()-1)
