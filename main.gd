extends Control

onready var play: Button = $"%play"
onready var stop: Button = $"%stop"
onready var clear: Button = $"%clear"
onready var freeze: Button = $"%freeze"
onready var log_day: Button = $"%log_day"

onready var timers: GridContainer = $"%timers"

onready var work_timer: TimeLabel = $"%work_timer"
onready var play_timer: TimeLabel = $"%play_timer"
onready var expected_finish: TimeLabel = $"%expected_finish"
onready var work_goal: TimeLabel = $"%work_goal"
onready var now: TimeLabel = $"%now"
onready var tasks = $"%tasks"

func _ready() -> void:
	play.connect("pressed",self,"_on_play_button_pressed")
	stop.connect("pressed",self,"_on_stop_button_pressed")
	clear.connect("pressed",self,"_on_clear_button_pressed")
	freeze.connect("pressed",self,"_on_freeze_button_pressed")
	log_day.connect("pressed",self,"_on_log_day_button_pressed")
	tasks.connect("task_time_changed", self, "_on_task_time_changed")
	work_timer.connect("msec_changed", tasks, "_on_work_done_updated")
	initialize()
	
func _on_task_time_changed(val):
	work_goal.msec = val
	work_goal.render_text()
func _on_play_button_pressed():
	unfreeze()
	set_stop(false)
	work_timer.switch()
	if work_timer.stopped:
		play_timer.on()
		play.text = "work"
	else:
		play_timer.off()
		play.text = "play"
		expected_finish.update_time()

var stop_pressed = false
func _on_stop_button_pressed():
	set_stop(!stop_pressed)
	
func set_stop(val):
	unfreeze()
	stop_pressed = val
	work_timer.set_frozen(stop_pressed)
	play_timer.set_frozen(stop_pressed)
	stop.pressed = stop_pressed

func _on_freeze_button_pressed():
	if frozen:
		unfreeze()
	else:
		freeze()

var frozen = false

func freeze():
	set_stop(false)
	frozen = true
	freeze.pressed = true
	for timer in timers.get_children():
		timer.freeze()
		
func unfreeze():
	frozen = false
	freeze.pressed = false
	for timer in timers.get_children():
		timer.unfreeze()


func _on_clear_button_pressed():
	work_timer.off()
	play_timer.off()
	
	work_timer.msec = 0
	work_timer.render_text()
	
	play_timer.msec = 0
	play_timer.render_text()
	
	work_goal.msec = 0
	work_goal.render_text()


onready var logs_file = Global.PATH.plus_file("history").plus_file("history.csv")
func _on_log_day_button_pressed():
	log_day()

func log_day():
	var file = FileUtils.open_or_create(logs_file)
	
	if file == null:
		return
		
	file.seek_end()

	# Header
	if file.get_len() == 0:
		file.store_csv_line(PoolStringArray([
			"day",
			"goal milliseconds",
			"work milliseconds",
			"play milliseconds"
		]))
	
	# Store line
	var line_text = store_line(
		file, 
		Time.get_date_string_from_system(),
		work_goal.msec,
		work_timer.msec,
		play_timer.msec
	)
	

	OS.clipboard = line_text
	print("entry \"{entry}\" copied to clipboard".format({"entry":line_text}))
	
	file.close()


static func store_line(file : File, date:String, goal_timer_msec:int, work_timer_msec:int, play_timer_msec:int):
	var line_start = file.get_position()
	
	var old_len = file.get_len()
	file.store_csv_line(PoolStringArray([
		date,
		Global.to_text(goal_timer_msec),
		Global.to_text(work_timer_msec),
		Global.to_text(play_timer_msec)
	]))
	var line_size = file.get_len()-old_len

	file.seek(line_start)
	return file.get_buffer(line_size-1).get_string_from_utf8()
	
	
func initialize():
	work_timer.off()
	play_timer.off()
	
	work_timer.render_text()
	
	play_timer.render_text()
	
	work_goal.render_text()
