extends Node
var interval := 5.0 setget set_interval
onready var timer := Timer.new()
onready var current_day : String = Calendar.today_to_string()

func _ready():
	add_child(timer)
	timer.one_shot = true
	timer.process_mode = Timer.TIMER_PROCESS_IDLE
	ConfigNode.find_config_and_connect(self, "init")
func init(config: ConfigMap):
	config.on_prop_change_notify_obj("auto_log", self, "set_auto_log")
	config.on_prop_change_notify_obj("auto_log_interval_seconds", self, "set_interval")
	timer.connect("timeout", self, "check")

var autolog := false


func set_auto_log(val):
	autolog = val
	if !autolog:
		timer.stop()
	elif timer.is_stopped():
		timer.start(interval)

func set_interval(val):
	interval = val
	if !timer.is_stopped() and timer.time_left > interval:
		timer.start(interval)
func check():
	if !autolog:
		return
	
	var today = Calendar.today_to_string()
	owner.log_day(current_day, true)
	
	if current_day != today:
		owner.cut_tasks_by_progress(true)
		current_day = today
	
	timer.start(interval)
	

