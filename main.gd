extends Control

onready var play: Button = $"%play"
onready var stop: Button = $"%stop"
onready var clear: Button = $"%clear"
onready var freeze: Button = $"%freeze"
onready var log_day: Button = $"%log_day"
onready var save: Button = $"%save"
onready var data_folder = $"%data_folder"


onready var timers: GridContainer = $"%timers"

onready var work_timer: TimeLabel = $"%work_timer"
onready var play_timer: TimeLabel = $"%play_timer"
onready var expected_finish: TimeLabel = $"%expected_finish"
onready var work_goal: TimeLabel = $"%work_goal"
onready var now: TimeLabel = $"%now"
onready var tasks = $"%tasks"
onready var progress = $"%progress"

func _ready() -> void:
	add_to_group("autosave_authority")
	
	play.connect("pressed", self, "_on_play_button_pressed")
	clear.connect("pressed", self, "clear")
	log_day.connect("pressed", self, "log_day")
	data_folder.connect("pressed", self, "data_folder")
	save.connect("pressed", self, "save")

	stop.connect("toggled", self, "set_stopped")
	freeze.connect("toggled", self, "set_frozen")
	autosave.connect("toggled", self, "set_should_autosave")

	work_timer.connect("msec_changed", self, "_work_timer_changed")
	tasks.connect("task_time_changed", self, "_on_task_time_changed")
	
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

func play():
	work_timer.off()
	play_timer.on()
	play.text = "work"
	play.hint_tooltip = "pause the Play timer and start the Work timer"
	play.theme = preload("work_theme.tres")
	tasks.paused = true

func work():
	work_timer.on()
	play_timer.off()
	play.text = "play"
	play.hint_tooltip = "pause the Work timer and start the Play timer"
	play.theme = preload("play_theme.tres")
	tasks.paused = false

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
	for timer in timers.get_children():
		timer.set_frozen(val)
	tasks.set_frozen(val)

func clear():
	play_timer.msec = 0
	tasks.clear_progress()
	set_stopped(true)
	

onready var LOGS_FILE = "history".plus_file("history.csv")
onready var LOGS_ABSOLUTE_PATH = OS.get_user_data_dir().plus_file(LOGS_FILE)
onready var LOGS_USER_PATH = Global.PATH.plus_file(LOGS_FILE)

func log_day():
	var file = FileUtils.open_or_create(LOGS_USER_PATH)
	
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
