extends Control

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

	work_timer.connect("msec_changed", self, "_work_timer_changed")
	tasks.connect("task_time_changed", self, "_on_task_time_changed")
	
	save_as_task_menu.play_timer = play_timer
	save_as_task_menu.task_panel = tasks
	save_as_task_menu.initialize()
	
	set_frozen(freeze.pressed)
	set_stopped(stop.pressed)
	
	ConfigNode.find_config_and_connect(self, "initialize")

	
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

func clear(all:=false):
	play_timer.msec = 0
	tasks.clear_progress(all)
	set_stopped(true)




func log_day(date, overwrite):
	var progress_map = tasks.get_progresses()
	History.log_day(date, progress_map, overwrite)

	if !overwrite: #remove all tasks that have been logged
		cut_tasks_by_progress(true)

func initialize(config: ConfigMap):
	config.on_prop_change_notify_obj("auto_save/enabled", self, "set_should_autosave")
	config.on_prop_change_notify_obj("auto_save/interval_seconds", self, "set_should_autosave")
	
	play()
	
	work_timer.render_text()
	play_timer.render_text()
	work_goal.render_text()

	tasks.calculate_tasks()

var should_autosave := false setget set_should_autosave
func set_should_autosave(val):
	should_autosave = val
	if !is_inside_tree() or Engine.editor_hint:
		return
	get_tree().call_group("autosave", "enable" if should_autosave else "disable")

var autosave_interval := 5.0 setget set_autosave_interval
func set_autosave_interval(val):
	autosave_interval = val
	if !is_inside_tree() or Engine.editor_hint:
		return
	get_tree().call_group("autosave", "set_interval", autosave_interval)


func save():
	get_tree().call_group("serializable", "save")


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

func cut_tasks_by_progress(all := false):
	tasks.cut_tasks_by_progress(all)
