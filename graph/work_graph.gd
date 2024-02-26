extends Control


var PROGRESS = preload("res://graph/progress.tscn")
var DATE = preload("res://graph/date.tscn")
onready var days = $"%days"
var colors = {}

var slots = []
var day_controls = []

export var seconds_per_pixel := 1.0

func _ready():
	refresh()

func refresh():
	var history : History.Log = History.retrieve_progress_history()
#	var max_ratio = 0.0
	for slot in slots:
		if is_instance_valid(slot):
			slot.queue_free()
	for day in day_controls:
		if is_instance_valid(day):
			day.queue_free()
			
	for date in history.get_dates():
		var day = DATE.instance()
		days.add_child(day)
		day_controls.append(day)
		var activity_map = history.get_activity_progress_map(date)
#		var accum_ratio = 0.0
		for activity in activity_map:
			var progress : Control = PROGRESS.instance()
			var time = activity_map[activity]
#			var ratio_of_day = (float(time)/(1000*60*60*24))
			
#			accum_ratio += ratio_of_day
			progress.rect_min_size.y = TimeUtils.mil_to_sec(time)/seconds_per_pixel
			slots.append(progress)
			if !colors.has(activity): 
				colors[activity] = Color(randf(),randf(),randf())
			progress.color = colors[activity]
			day.add_child(progress)
#		max_ratio = max(max_ratio, accum_ratio)
#		print(max_ratio)
#	if max_ratio > 0.0:
#		var scale = 0.8/max_ratio
#		for slot in slots:
#			slot.rect_min_size.y *= scale
