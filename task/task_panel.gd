extends PanelContainer
signal task_time_changed(task_time_completed_msec, task_time_msec)
signal updated()

signal pause(val)

const Task = preload("task.gd")
const FileUtils = preload("res://utils/FileUtils.gd")
const DeltaTimer = preload("res://utils/time/delta_timer.gd")

const TASK = preload("task.tscn")


onready var add = $"%add"
onready var task_list = $"%task_list"
onready var autosave = $"%autosave"
onready var drop_space = $"%drop_space"

onready var filter_by_name_edit = $"%filter_by_name_edit"
onready var filter_by_name_button = $"%filter_by_name_button"
onready var clear_search_button = $"%clear_search_button"
onready var config = $"%config"
onready var sound = $"%sound"

var dt = DeltaTimer.new()

var msec_completed = 0

var tasks = []

func _ready():
	if Engine.editor_hint:
		return
	add_to_group("serializable")
	autosave.connect("triggered", self, "save")
	connect("updated", autosave, "trigger")
	
	add.connect("pressed", self, "add_task")
	add.add_to_group("shine_on_advice_start_task")
	
	filter_by_name_button.connect("pressed", self, "_on_filter_by_name_button_pressed")
	filter_by_name_edit.connect("text_entered", self, "filter_by_name")
	clear_search_button.connect("pressed", self, "_on_clear_search_button_pressed")
	drop_space.connect("dropped", self, "reorder")
	load_()
	
	ConfigNode.find_config_and_connect(self, "initialize_from_config")

func initialize_from_config(config_map: ConfigMap):
	config_map.on_prop_change_notify_obj("alert_on_task_completed", self, "set_alert_on_completion")
	config_map.on_prop_change_notify_obj("hide_completed_tasks", self, "set_hide_completed_tasks")
	config_map.on_prop_change_notify_obj("progress_tasks_in_parallel", self, "set_progress_tasks_in_parallel")

var progress_tasks_in_parallel := false setget set_progress_tasks_in_parallel
func set_progress_tasks_in_parallel(val):
	progress_tasks_in_parallel = val



func _on_filter_by_name_button_pressed():
	filter_by_name(filter_by_name_edit.text)

func filter_by_name(text: String):
	for t in tasks:
		var task : Task = t
		if text.empty() or task.title.find(text) != -1:
#			task.show()
			task.set_enabled(true)
		else:
#			task.hide()
			task.set_enabled(false)

func register_work(activity:String, millis_done:int):
	for t in tasks:
		var task = t as Task
		if task.title == activity:
			millis_done = task.add_progress(millis_done)
			if !millis_done:
				return
	add_task(activity, millis_done, millis_done)

func add_task(title:="", millis_target:=0, millis_done:=0):
	var task = TASK.instance()
	add_task_internal(task)
	task.set_title(title)
	task.set_msec(millis_target)
	task.set_msec_done(millis_done)
	calculate_tasks()

func add_task_internal(task):
	task.set_paused(paused)
	task.connect("updated", self, "calculate_tasks")
	task.connect("deleting", self, "remove_from_tasks", [task])
	task.connect("tree_entered", self, "add_to_tasks", [task])
	connect("pause", task, "set_paused")
	task_list.add_child(task)
	task.connect("completed", self, "_on_task_completed", [task])

var hide_completed_tasks = false setget set_hide_completed_tasks
func set_hide_completed_tasks(val):
	hide_completed_tasks = val
	refresh_hide_completed_tasks()

var alert_on_completion = false setget set_alert_on_completion
func set_alert_on_completion(val):
	alert_on_completion = val
func _on_task_completed(_task):
	sound.play()
	refresh_hide_completed_tasks()

var save_queued = false
func queue_save():
	if save_queued:
		return
	save_queued = true
	get_tree().connect("idle_frame", self, "save", [], CONNECT_ONESHOT)

func add_to_tasks(task):
	tasks.append(task)
	queue_save()
func remove_from_tasks(task):
	tasks.erase(task)
	queue_save()
func _on_work_done_updated(msec):
	msec_completed = msec
#	update_task_completeness()

func update_task_completeness():
	var sum = msec_completed
	for task in tasks:
		if !task.enabled:
			continue
		var task_msec = task.msec
		if sum >= task_msec:
			sum -= task_msec
			task.msec_done = task_msec
		else:
			task.msec_done = sum
			sum = 0

func calculate_tasks():
	var sum = 0
	var completed_sum = 0
	for task in tasks:
		if !task.enabled:
			continue
		sum += task.msec
		completed_sum += task.msec_done
	emit_signal("task_time_changed", completed_sum, sum)
	emit_signal("updated")

func refresh_hide_completed_tasks():
	for task in tasks:
		task.visible = !hide_completed_tasks or !task.completed

func clear_progress(all := false):
	for task in tasks:
		if !all and !task.enabled:
			continue
		task.msec_done = 0
	calculate_tasks()

onready var FILE = Global.PATH.plus_file("config").plus_file("tasks.json") 
func save():
	var serialized_tasks = []
	tasks.sort_custom(self, "sort_by_index")
	for task in tasks:
		var serialized_task = task.serialize()
		serialized_tasks.append(serialized_task)
	FileUtils.save_json_file(FILE, {tasks=serialized_tasks})
	save_queued = false
func sort_by_index(a: Task, b: Task) -> bool:
	return a.get_index() < b.get_index()

func load_():
	var res = FileUtils.load_json_file_as_dict(FILE)
	if !res or not "tasks" in res:
		return
	for serialized_task in res.tasks:
		var task = TASK.instance()
		task.deserialize(serialized_task)
		add_task_internal(task)
	calculate_tasks()

func enable_task(_task):
	calculate_tasks()
func disable_task(_task):
	calculate_tasks()

export var paused := false setget set_pause
func set_pause(val):
	paused = val
	update_process()
func pause():
	set_pause(true)
func unpause():
	set_pause(false)

export var frozen := false setget set_frozen
func set_frozen(val):
	frozen = val
	update_process()

func update_process():
	var should_pause = frozen or paused
	emit_signal("pause", should_pause)

func reorder(task: Task, to_position: int):
	self.task_list.move_child(task, to_position)
	queue_save()

func _on_clear_search_button_pressed():
	filter_by_name("")
func log_day():
	pass

#func _process(_delta):
#	time_step(dt.get_and_reset())

func time_step(delta: int):
	add_progress(delta)

onready var no_tasks_alert = $"%no_tasks_alert"

func add_progress(delta: int):
	if !delta:
		return
	
	if progress_tasks_in_parallel:
		delta = add_progress_parallel(delta)
	else:
		delta = add_progress_sequential(delta)
		
	if !delta:
		return
	
	owner.play()
	owner.play_timer.add_delta(delta)
	if alert_on_completion:
		if !OS.is_window_focused():
			OS.move_window_to_foreground()
			OS.alert("No selected tasks left! Select a new task.", "Tasks finished!")
		no_tasks_alert.popup()
		sound.play()

func add_progress_sequential(delta : int) -> int:
	for t in tasks:
		var task : Task = t
		if task.is_able_to_process():
			delta = task.add_progress(delta)
			if !delta:
				return delta
	return delta

func add_progress_parallel(delta : int) -> int:
	var leftover = delta
	for t in tasks:
		var task : Task = t
		if task.is_able_to_process():
			var current_leftover = task.add_progress(delta)
			# if one big delta happens, several tasks might complete simultaneously, 
			# the leftover is the lowest one of all leftovers
			leftover = MathUtils.mini(leftover, current_leftover)
	return leftover

# map[activity]->time
func get_progresses() -> Dictionary:
	var ret = {}
	for t in tasks:
		var task : Task = t
		var title = task.title
		var accum : int = ret.get(title, 0)
		ret[title] = accum + task.msec_done
	return ret

func cut_tasks_by_progress(all := false):
	for t in tasks:
		var task : Task = t
		if !all and !task.enabled:
			continue
		task.msec = MathUtils.maxi(0, task.msec - task.msec_done)
		task.msec_done = 0
		if task.msec == 0:
			task.remove()
	calculate_tasks()
