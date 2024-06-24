extends Node

var interval_regex := RegEx.new()


func _ready():
	interval_regex.compile("=+")
	
	
	test_case("""
		dev      :_===__________=________
		work     :____===_==__==_________
		food     :_______=_______________
		doctor   :__________==___________
		sleep    :_______________========
		""")
	test_case("""
		dev      :_===__________=________
		work     :____===_==__==_________
		food     :_______=_______________
		doctor   :__________==___________
		sleep    :_______________=======_
		end      :______________________=
		""")
	
	
	
	get_tree().quit(0)


func test_case(
	case: String
):
	var timeline = Timeline.new()
	
	print("TEST CASE")
	case = case.dedent().strip_edges()
	print(case)
	print()
	
	var map := {}
	var events := []
	var lines = case.split("\n")
	var line_length : int = lines[0].split(":")[1].length()
	for line in lines:
		var l : String = line
		var arr := l.split(":")
		var activity := arr[0].strip_edges()
		var schedule := arr[1]
		var res := interval_regex.search_all(schedule)
		var expected_res := PoolIntArray()
		var starts := PoolIntArray()
		
		var expected_timer = LogBasedTimer.new()
		for i in res.size():
			var m : RegExMatch = res[i]
			var start := m.get_start()
			var end := m.get_end()
			starts.append(start)
			expected_res.append(start)
			expected_res.append(end)
		
		for entry in expected_res:
			if entry != line_length:
				expected_timer.toggle_at(entry)
		map[activity] = {
			inputs = starts,
			expected_timer = expected_timer
		}
	
	for activity in map.keys():
		var inputs = map[activity].inputs
		for i in inputs.size():
			events.push_back({
				activity = activity,
				time = inputs[i]
			})
	events.sort_custom(self, "sort")
	
	for event in events:
		timeline.start_at(event.activity, event.time)
	
		
	for activity in map.keys():
		var entry = map[activity]
		var expected : LogBasedTimer = entry.expected_timer
		var actual : LogBasedTimer = timeline.activities[activity]
		print(activity)
		print("expected :%s" % tostr(expected, line_length))
		print("actual   :%s" % tostr(actual, line_length))
		assert(expected.get_time_at(line_length) == actual.get_time_at(line_length))
		assert(expected.entries == actual.entries)
		print()

func tostr(timer: LogBasedTimer, at: int):
	var prev := 0
	var entry := 0
	var ret = ""
	for i in timer.entries.size():
		prev = entry
		entry = timer.entries[i]
		var length := entry-prev
		if i%2:
			ret += "=".repeat(length)
		else:
			ret += "_".repeat(length)
	if timer.is_running():
		ret = StringUtils.padr(ret, at, "=")
	else:
		ret = StringUtils.padr(ret, at, "_")
	return ret + " (time: %02d, entries: %02d)%s" % [timer.get_time_at(at), timer.entries.size(), timer.entries]
func sort(a, b):
	return a.time < b.time
