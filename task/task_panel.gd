extends PanelContainer
signal task_time_changed(task_time_msec)

const Task = preload("task.tscn")

onready var add = $"%add"
onready var task_list = $"%task_list"

var msec_completed = 0

func _ready():
	add.connect("pressed", self, "add_task")
	load_()
	
var active_tasks = {}
func add_task():
	var task = Task.instance()
	add_task_internal(task)
	calculate_tasks()

func add_task_internal(task):
	task.connect("msec_updated", self, "_on_msec_updated", [task], CONNECT_DEFERRED)
	task.connect("disabled", self, "disable_task", [task])
	task.connect("enabled", self, "enable_task", [task])
	
	task_list.add_child(task)


func _on_msec_updated(new_msec, task):
	calculate_tasks()

func _on_work_done_updated(msec):
	msec_completed = msec
	update_task_completeness()

func update_task_completeness():
	var sum = msec_completed
	for task in active_tasks:
		var task_msec = task.msec
		if sum >= task_msec:
			sum -= task_msec
			task.msec_done = task_msec
		else:
			task.msec_done = sum
			sum = 0

func calculate_tasks():
	var sum = 0
	for task in active_tasks:
		sum += task.msec
	emit_signal("task_time_changed", sum)
	save()


onready var FILE = Global.PATH.plus_file("config").plus_file("tasks.json") 
func save():
	var serialized_tasks = []
	for task in task_list.get_children():
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
func enable_task(task):
	active_tasks[task] = task
	calculate_tasks()
func disable_task(task):
	active_tasks.erase(task)
	calculate_tasks()
