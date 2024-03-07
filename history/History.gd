extends Node
class_name History
const LOGS_DIR = "history"
const LOGS_FILE = "history.csv"

class Log:
	var activity_date_progress_map := {}
	var date_activity_progress_map := {}
	
	func get_progress(activity: String, date: String) -> int:
		return activity_date_progress_map.get(activity, {}).get(date, 0)
	
	func set_progress(activity: String, date: String, progress: int):
		var date_progress_map = MapUtils.put_if_absent(activity_date_progress_map, activity, {})
		var activity_progress_map = MapUtils.put_if_absent(date_activity_progress_map, date, {})
		
		date_progress_map[date] = progress
		activity_progress_map[activity] = progress
		
	func add_progress(activity: String, date: String, progress: int):
		set_progress(activity, date, get_progress(activity, date) + progress)
	
	func get_dates() -> PoolStringArray:
		var ret = PoolStringArray(date_activity_progress_map.keys())
		ret.sort()
		return ret
	func get_activities() -> PoolStringArray:
		var ret = PoolStringArray(activity_date_progress_map.keys())
		ret.sort()
		return ret

	func get_date_progress_map(activity: String):
		return activity_date_progress_map.get(activity, {})
	func get_activity_progress_map(date: String):
		return date_activity_progress_map.get(date, {})
		
	func is_empty():
		return activity_date_progress_map.empty()
	
	func get_max_progress():
		var max_progress = 0
		for date in date_activity_progress_map:
			var progresses = date_activity_progress_map[date].values()
			var combined_progress: int = 0
			for progress in progresses:
				combined_progress += progress
			max_progress = MathUtils.maxi(max_progress, combined_progress)
		return max_progress
	
	func duplicate() -> Log:
		var ret : Log = Log.new()
		ret.activity_date_progress_map = self.activity_date_progress_map.duplicate(true)
		ret.activity_date_progress_map = self.activity_date_progress_map.duplicate(true)
		return ret
	
	func filter(activities_to_include: Array) -> Log:
		var copy: Log = Log.new()
		for activity in activities_to_include:
			var date_progress_map = activity_date_progress_map.get(activity, {})
			for date in date_progress_map:
				var progress = date_progress_map[date]
				copy.set_progress(activity, date, progress)
		return copy
	
	
	func join_activities_array(activities:Array, final_activity:String):
		for activity in activities:
			join_activities(activity, final_activity)
	func join_activities(activity, final_activity):
		if activity == final_activity:
			return
		if !activity_date_progress_map.has(activity):
			return
		if !activity_date_progress_map.has(final_activity):
			_overwrite_activity(activity, final_activity)
		else:
			_add_activity(activity, final_activity)
		remove_activity(activity)
	func remove_activity(activity):
		activity_date_progress_map.erase(activity)
		for activity_progress_map in date_activity_progress_map.values():
			activity_progress_map.erase(activity)
	func _overwrite_activity(from, to):
		activity_date_progress_map[to] = activity_date_progress_map[from]
		for activity_progress_map in date_activity_progress_map.values():
			if !activity_progress_map.has(from):
				continue
			activity_progress_map[to] = activity_progress_map[from]
	func _add_activity(from, to):
		var date_progress_map = activity_date_progress_map[from]
		for date in date_progress_map:
			add_progress(to, date, date_progress_map[date])

func _init():
	var msg = "%s is an utility class, you are not supposed to instantiate it." % get_script().resource_path
	assert(false, msg)
	printerr(msg)

static func path() -> String:
	return Global.PATH.plus_file(LOGS_DIR).plus_file(LOGS_FILE)


static func store_history(file: File, history: Log):
	DebugUtils.print("saving history:")
	DebugUtils.print(JSON.print(history.activity_date_progress_map, ".\t"))
	for date in history.get_dates():
		var line = history.get_activity_progress_map(date)
		var res = store_line(file, date, line)
		DebugUtils.print(res)

static func store_line(file: File, date: String, progress_map: Dictionary):
	var line_start = file.get_position()
	
	var old_len = file.get_len()
	
	var arr = [date]
	arr.resize(progress_map.size()+1)
	var keys = progress_map.keys()
	keys.sort()
	for i in keys.size():
		var key: String = keys[i]
		var value: int = progress_map[key]
		arr[i+1] = "%s=%s" % [key.http_escape(), str(value)]
	
	file.store_csv_line(PoolStringArray(arr))
	var line_size = file.get_len()-old_len

	file.seek(line_start)
	return file.get_buffer(line_size).get_string_from_utf8().strip_edges()

# map[activity][date] -> time
static func retrieve_progress_history(path := path()) -> Log:
	var file = FileUtils.open_or_create(path)
	var history = Log.new()
	while file.get_position() < file.get_len():
		var line: PoolStringArray = file.get_csv_line()
		var date: String = line[0]
		for i in range(1, line.size()):
			var text: String = line[i]
			var entry: Array = text.split("=")
			var activity: String = entry[0].http_unescape()
			var progress: int = int(entry[1])
			history.add_progress(activity, date, progress)
			
	return history


static func log_day(date, progress_map, overwrite_day, path := path()):
	var file = FileUtils.open_or_create(path)
	if file == null:
		return
	
	if overwrite_day and file.get_len() > 0:
		var history = retrieve_progress_history()
		file.close()
		
		for activity in progress_map:
			var time = progress_map[activity]
			history.set_progress(activity, date, time)
		
		var aux_path = path+".aux"
		var aux_file = FileUtils.open_or_create(aux_path, File.WRITE_READ)
		store_history(aux_file, history)
		
		var error = FileUtils.rename(aux_path, path)
		if error:
			push_error("Couldn't save history")
	else:
		
		file.seek_end()
		# Store line
#		var line_text = 
		store_line(
			file, 
			date,
			progress_map
		)

#		OS.clipboard = line_text
#		print("entry \"{entry}\" copied to clipboard".format({"entry":line_text}))
		file.close()
