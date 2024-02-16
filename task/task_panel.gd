extends PanelContainer
signal task_time_changed(task_time_completed_msec, task_time_msec)
signal updated()
signal pause(val)

const Task = preload("task.tscn")

onready var add = $"%add"
onready var task_list = $"%task_list"
onready var autosave = $"%autosave"
onready var drop_space = $"%drop_space"

var msec_completed = 0

var tasks = []

func _ready():
	if Engine.editor_hint:
		return
	add_to_group("serializable")
	autosave.connect("triggered", self, "save")
	connect("updated", autosave, "trigger")
	
	add.connect("pressed", self, "add_task")
	load_()
	
func add_task():
	var task = Task.instance()
	add_task_internal(task)
	calculate_tasks()

func add_task_internal(task):
	task.set_paused(paused)
	task.connect("updated", self, "calculate_tasks")
	task.connect("tree_exiting", self, "remove_from_tasks", [task])
	task.connect("tree_entered", self, "add_to_tasks", [task])
	connect("pause", task, "set_paused")
	task_list.add_child(task)

func add_to_tasks(task):
	tasks.append(task)
func remove_from_tasks(task):
	tasks.erase(task)

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

func clear_progress():
	for task in tasks:
		if !task.enabled:
			continue
		task.msec_done = 0
	calculate_tasks()


onready var FILE = Global.PATH.plus_file("config").plus_file("tasks.json") 
func save():
	var serialized_tasks = []
	for task in tasks:
		var serialized_task = task.serialize()
		serialized_tasks.append(serialized_task)
	FileUtils.save_json_file(FILE, {tasks=serialized_tasks})

func load_():
	var res = FileUtils.load_json_file_as_dict(FILE)
	if !res or not "tasks" in res:
		return
	for serialized_task in res.tasks:
		var task = Task.instance()
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
	
