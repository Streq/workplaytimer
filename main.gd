extends Control
signal time_step(delta)

const FileUtils = preload("res://utils/FileUtils.gd")

onready var play: Button = $"%play"
onready var stop: Button = $"%stop"
onready var clear: Button = $"%clear"
onready var freeze: Button = $"%freeze"
onready var log_day: Button = $"%log_day"
onready var save: Button = $"%save"
onready var data_folder = $"%data_folder"

onready var log_day_menu = $"%log_day_menu"


onready var timers: GridContainer = $"%timers"

onready var work_timer: TimeLabel = $"%work_timer"
onready var play_timer: TimeLabel = $"%play_timer"
onready var expected_finish: TimeLabel = $"%expected_finish"
onready var work_goal: TimeLabel = $"%work_goal"
onready var remainder = $"%remainder"
onready var now: TimeLabel = $"%now"

onready var tasks = $"%task_panel"
onready var progress = $"%progress"

onready var save_as_task_menu = $"%save_as_task_menu"


func _ready() -> void:
	add_to_group("autosave_authority")
	add_to_group("main")
	
	remainder.work_goal = work_goal
	remainder.work_timer = work_timer
	remainder.initialize()
	
	expected_finish.work_goal = work_goal
	expected_finish.work_timer = work_timer
	expected_finish.remainder = remainder
	expected_finish.now = now
	expected_finish.initialize()
	
	play.connect("pressed", self, "_on_play_button_pressed")
	clear.connect("pressed", self, "clear")
	log_day_menu.connect("submit", self, "log_day")
	data_folder.connect("pressed", self, "data_folder")
	save.connect("pressed", self, "save")

	stop.connect("toggled", self, "set_stopped")
	freeze.connect("toggled", self, "set_frozen")
	autosave.connect("toggled", self, "set_should_autosave")

	work_timer.connect("msec_changed", self, "_work_timer_changed")
	tasks.connect("task_time_changed", self, "_on_task_time_changed")
	
	save_as_task_menu.play_timer = play_timer
	save_as_task_menu.task_panel = tasks
	save_as_task_menu.initialize()
	
	set_frozen(freeze.pressed)
	set_stopped(stop.pressed)
	set_should_autosave(autosave.pressed)
	
	initialize()

	
func data_folder():
	FileUtils.open_user_data()
	
func _work_timer_changed(msec):
	tasks._on_work_done_updated(msec)
#	update_subtract_leftover()

func _on_task_time_changed(completed_msec, val):
	work_timer.msec = completed_msec
	work_goal.msec = val
	work_timer.render_text()
	work_goal.render_text()
	progress.update_progress()

func _on_play_button_pressed():
	set_frozen(false)
	set_stopped(false)
	if play_timer.stopped:
		play()
	else:
		work()

var working := false
func play():
	work_timer.off()
	play_timer.on()
	play.text = "work"
	play.hint_tooltip = "pause the Play timer and start the Work timer"
	play.theme = preload("work_theme.tres")
	working = false
func work():
	work_timer.on()
	play_timer.off()
	play.text = "play"
	play.hint_tooltip = "pause the Work timer and start the Play timer"
	play.theme = preload("play_theme.tres")
	working = true
var stopped = false
func _on_stop_button_pressed():
	set_stopped(!stopped)

func set_stopped(val):
	if val and frozen:
		set_frozen(false)
	stopped = val
	tasks.set_frozen(stopped)
	play_timer.set_frozen(stopped)
	stop.pressed = stopped
	

func _on_freeze_button_toggled(val):
	set_frozen(val)

var frozen = false

func set_frozen(val):
	if val and stop:
		set_stopped(false)

	frozen = val
	freeze.pressed = val

func clear():
	play_timer.msec = 0
	tasks.clear_progress()
	set_stopped(true)


onready var LOGS_FILE = "history".plus_file("history.csv")
onready var LOGS_ABSOLUTE_PATH = OS.get_user_data_dir().plus_file(LOGS_FILE)
onready var LOGS_USER_PATH = Global.PATH.plus_file(LOGS_FILE)

func log_day(date):
	var file = FileUtils.open_or_create(LOGS_USER_PATH)
	
	if file == null:
		return
	file.seek_end()
	
	var progress_map = tasks.get_progresses()
	
	# Store line
	var line_text = store_line(
		file, 
		date,
		progress_map
	)

	OS.clipboard = line_text
	print("entry \"{entry}\" copied to clipboard".format({"entry":line_text}))
	
	file.seek(0)
	print(retrieve_progress_history(file))
	file.close()


static func store_line(file : File, date: String, progress_map: Dictionary):
	var line_start = file.get_position()
	
	var old_len = file.get_len()
	
	var arr = [date]
	arr.resize(progress_map.size()+1)
	var keys = progress_map.keys()
	for i in keys.size():
		var key: String = keys[i]
		var value: int = progress_map[key]
		arr[i+1] = "%s=%s" % [key.http_escape(), str(value)]
	
	file.store_csv_line(PoolStringArray(arr))
	var line_size = file.get_len()-old_len

	file.seek(line_start)
	return file.get_buffer(line_size-1).get_string_from_utf8()

static func retrieve_progress_history(file : File)->Dictionary:
	var history = {}
	while file.get_position() < file.get_len():
		var line: PoolStringArray = file.get_csv_line()
		var date: String = line[0]
		for i in range(1, line.size()):
			var text: String = line[i]
			var entry: Array = text.split("=")
			var activity: String = entry[0].http_unescape()
			var progress: int = int(entry[1])
			
			if !history.has(activity):
				history[activity] = {}
			
			var history_activity : Dictionary = history.get(activity)
			history_activity[date] = progress
	return history
func initialize():
	play()
	
	work_timer.render_text()
	play_timer.render_text()
	work_goal.render_text()

	tasks.calculate_tasks()
	
func save():
	get_tree().call_group("serializable", "save")

onready var autosave = $"%autosave"
var should_autosave := false setget set_should_autosave
func set_should_autosave(val):
	autosave = val
	if !is_inside_tree() or Engine.editor_hint:
		return
	get_tree().call_group("autosave", "enable" if autosave else "disable")

const DeltaTimer = preload("res://utils/time/delta_timer.gd")
var dt = DeltaTimer.new()
func _process(_delta):
	var delta = dt.get_and_reset()
	
	if frozen:
		return
	
	if !stopped:
		if working:
			tasks.time_step(delta)
		else:
			play_timer.time_step(delta)
	
	now.update_time()
	
	
	
