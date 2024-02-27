extends Control


var PROGRESS = preload("res://graph/progress.tscn")
var DATE = preload("res://graph/date.tscn")
onready var days = $"%days"
var colors = {}

var dates = {}
var activity_nodes = {}


onready var days_node = $"%days"


func refresh():
	var history : History.Log = History.retrieve_progress_history()
	var max_progress = 0
	
	if history.is_empty():
		return
		
	var used_dates = history.get_dates()
	var first_date = used_dates[0]
	var last_date = used_dates[used_dates.size()-1]
	var all_dates = get_all_dates_between(first_date, last_date)
	
	for date in all_dates:
		var date_node = DATE.instance()
		dates[date] = date_node
		days_node.add_child(date_node)
		date_node.set_date(date)
	for date in used_dates:
		var map = history.get_activity_progress_map(date)
		for activity in map:
			var date_node = dates[date]
			var progress_node = date_node.add_activity(activity, map[activity])
			MapUtils.put_if_absent(activity_nodes, activity, [])
			activity_nodes[activity].append(progress_node)

	for date in used_dates:
		var date_node = dates[date]
		max_progress = max(max_progress, date_node.total_progress)
	for date in used_dates:
		var date_node = dates[date]
		date_node.set_total_time(max_progress)

	for activity in activity_nodes:
		var color = Color(randi() | 0xff)
		for node in activity_nodes[activity]:
			node.color = color

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
