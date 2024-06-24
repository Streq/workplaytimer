extends Node


var interval_regex := RegEx.new()
var removal_regex := RegEx.new()

var interval_start_regex := RegEx.new()
var interval_end_regex := RegEx.new()

func _ready():
	
	# find every sequence of |
	interval_regex.compile("\\|+")
	
	# find every | that is not preceded by a |
	interval_start_regex.compile("(?<!\\|)\\|")
	
	# find every | that is not succeeded by a | or the end of the String
	interval_end_regex.compile("\\|(?!\\||$)")

	# find every sequence of x
	removal_regex.compile("x+")

	
	var timer := LogBasedTimer.new()
	var accum := 0
	
	timer.toggle()
	var begin = timer.entries[0]
	timer.toggle_at(begin+1000)
	accum = timer.get_time()
	assert(accum == 1000)
	
	timer.toggle_at(begin+2000)
	timer.toggle_at(begin+3000)
	accum = timer.get_time()
	assert(accum == 2000)

	timer.insert_active_range(begin, begin+3000)
	accum = timer.get_time()
	assert(accum == 3000)
	assert(timer.entries.size() == 2)
	
	timer.remove_active_range(begin, begin+2500)
	accum = timer.get_time()
	assert(accum == 500)
	assert(timer.entries.size() == 2)
	
	timer.insert_active_range(begin, begin+2500)
	accum = timer.get_time()
	assert(accum == 3000)
	assert(timer.entries.size() == 2)
	
	# Removal tests

	insertion_test(
		"-------|||||--------",
		"-----xxxxxxxxx------",
		"--------------------"
	)
	insertion_test(
		"-------|||||--------",
		"-------xxxxxxxx-----",
		"--------------------"
	)
	insertion_test(
		"-------|||||--------",
		"----xxxxxxxx--------",
		"--------------------"
	)
	insertion_test(
		
		"-------|||||--------",
		"-------xxxxx--------",
		"--------------------"
	)
	insertion_test(
		"-------|||||--------",
		"----xxxxx-----------",
		"---------|||--------"
	)
	insertion_test(
		"-------|||||--------",
		"----------xxxxx-----",
		"-------|||----------"
	)
	insertion_test(
		"-------|||||--------",
		"-------xxx----------",
		"----------||--------"
	)
	insertion_test(
		"-------|||||-------",
		"---------xxx-------",
		"-------||----------"
	)
	insertion_test(
		"-------|||||--------",
		"------xxx-----------",
		"---------|||--------"
	)
	insertion_test(
		"------|||||||-------",
		"--------xxx---------",
		"------||---||-------"
	)

	insertion_test(
		"-|||||-|||||-|||||-",
		"---xxxxxxxxxxxxx---",
		"-||-------------||-"
	)
	
	# open ended timers
	
	insertion_test(
		"------|||||||||||||",
		"---xxxxxxxxxxxxx---",
		"----------------|||"
	)
	insertion_test(
		"------|||||||||||||",
		"------xxxxxxxxxx---",
		"----------------|||"
	)
	insertion_test(
		"------|||||||||||||",
		"--------xxxxxxxx---",
		"------||--------|||"
	)
	
	insertion_test(
		"--||||----|||||||||",
		"-xxxxxx------------",
		"----------|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"--xxxxx------------",
		"----------|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"-xxxxx-------------",
		"----------|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"--xxxx-------------",
		"----------|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"--xxx--------------",
		"-----|----|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"---xxx-------------",
		"--|-------|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"-xxx---------------",
		"----||----|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"----xxx------------",
		"--||------|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"---xx--------------",
		"--|--|----|||||||||"
	)
	
	insertion_test(
		"--||||----|||||||||",
		"-xxxxxxxxxxxxx-----",
		"--------------|||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"----xxxxxxxxxx-----",
		"--||----------|||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"----xxxxxx---------",
		"--||------|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"-xxxxxx------------",
		"----------|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"------xxxxxxx------",
		"--||||-------||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"------xxxx---------",
		"--||||----|||||||||"
	)

	insertion_test(
		"-|||||-|||||-||||||",
		"---xxxxxxxxxxxxx---",
		"-||-------------|||"
	)
	
	
	# INSERTION TESTS
	insertion_test(
		"-------|||||--------",
		"-----|||||||||------",
		"-----|||||||||------"
	)
	insertion_test(
		"-------|||||--------",
		"-------||||||||-----",
		"-------||||||||-----"
	)
	insertion_test(
		"-------|||||--------",
		"----||||||||--------",
		"----||||||||--------"
	)
	insertion_test(
		
		"-------|||||--------",
		"-------|||||--------",
		"-------|||||--------"
	)
	insertion_test(
		"-------|||||--------",
		"----|||||-----------",
		"----||||||||--------"
	)
	insertion_test(
		"-------|||||--------",
		"----------|||||-----",
		"-------||||||||-----"
	)
	insertion_test(
		"-------|||||--------",
		"-------|||----------",
		"-------|||||--------"
	)
	insertion_test(
		"-------|||||--------",
		"---------|||--------",
		"-------|||||--------"
	)
	insertion_test(
		"-------|||||--------",
		"------|||-----------",
		"------||||||--------"
	)
	insertion_test(
		"------|||||||-------",
		"--------|||---------",
		"------|||||||-------"
	)

	insertion_test(
		"-|||||-|||||-|||||--",
		"---|||||||||||||----",
		"-|||||||||||||||||--"
	)
	
	# open ended timers
	
	insertion_test(
		"------|||||||||||||",
		"---|||||||||||||---",
		"---||||||||||||||||"
	)
	insertion_test(
		"------|||||||||||||",
		"------||||||||||---",
		"------|||||||||||||"
	)
	insertion_test(
		"------|||||||||||||",
		"--------||||||||---",
		"------|||||||||||||"
	)
	
	insertion_test(
		"--||||----|||||||||",
		"-||||||------------",
		"-||||||---|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"--|||||------------",
		"--|||||---|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"-|||||-------------",
		"-|||||----|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"--||||-------------",
		"--||||----|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"--|||--------------",
		"--||||----|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"---|||-------------",
		"--||||----|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"-|||---------------",
		"-|||||----|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"----|||------------",
		"--|||||---|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"---||--------------",
		"--||||----|||||||||"
	)
	
	insertion_test(
		"--||||----|||||||||",
		"-|||||||||||||-----",
		"-||||||||||||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"----||||||||||-----",
		"--|||||||||||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"----||||||---------",
		"--|||||||||||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"-||||||------------",
		"-||||||---|||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"------|||||||------",
		"--|||||||||||||||||"
	)
	insertion_test(
		"--||||----|||||||||",
		"------||||---------",
		"--|||||||||||||||||"
	)

	insertion_test(
		"-|||||-|||||-||||||",
		"---|||||||||||||---",
		"-||||||||||||||||||"
	)
	
func insertion_test(ts:String, tr:String, te:String):
	var expected_timer := LogBasedTimer.new()
	insert(expected_timer, te)
	var expected_time := expected_timer.get_time_at(te.length())
	var expected_entries := expected_timer.entries
	var expected_entry_count := expected_entries.size()

	var removal_timer := LogBasedTimer.new()
	insert(removal_timer, tr.replace("x","|"))
	
	var timer := LogBasedTimer.new()
	insert(timer, ts)
	
	print("TEST CASE")
	print("initial: %s (time:%02d, count:%02d)%s" % [ts, timer.get_time_at(ts.length()), timer.entries.size(), timer.entries])
	print("removal: %s (time:%02d, count:%02d)%s" % [tr, removal_timer.get_time_at(ts.length()), removal_timer.entries.size(), removal_timer.entries])
	print("expected:%s (time:%02d, count:%02d)%s" % [te, expected_time, expected_entry_count, expected_entries])
	insert(timer, tr)
	
	var actual_time :=  timer.get_time_at(ts.length())
	var actual_entries := timer.entries
	var actual_entry_count := actual_entries.size()
	

	var text_res : String = ""
	var prev := 0
	var entry := 0
	for i in actual_entry_count:
		prev = entry
		entry = actual_entries[i]
		
		if i%2 == 0:
			text_res += "-".repeat(entry - prev)
		else:
			text_res += "|".repeat(entry - prev)
	if timer.is_running():
		text_res += "|".repeat(ts.length()-text_res.length())
	else:
		text_res += "-".repeat(ts.length()-text_res.length())

	print("result:  %s (time:%02d, count:%02d)%s" % [text_res, actual_time, actual_entries.size(), actual_entries])
	print()
	
	assert(text_res == te)
	assert(actual_entries == expected_entries)
	assert(actual_time == expected_time)
	
	
	get_tree().quit()

func insert(timer: LogBasedTimer, ts: String):
	var res = interval_regex.search_all(ts)
	for regex_match in res:
		var m : RegExMatch = regex_match
		var start = m.get_start()
		var end = m.get_end()
		if end < ts.length():
			timer.insert_active_range(start, end)
		else:
			timer.start_at(start)

	res = removal_regex.search_all(ts)
	for regex_match in res:
		var m : RegExMatch = regex_match
		var start = m.get_start()
		var end = m.get_end()
		if end < ts.length():
			timer.remove_active_range(start, end)

