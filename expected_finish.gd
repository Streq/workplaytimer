extends TextEdit

export var remainder_path : NodePath
onready var remainder = get_node(remainder_path)
export var timer_path : NodePath
onready var timer = get_node(timer_path)
export var goal_path : NodePath
onready var goal = get_node(goal_path)


func _process(delta: float) -> void:
	update_time()

func _ready() -> void:
	timer.connect("started",self,"set_process",[false])
	timer.connect("stopped",self,"set_process",[true])
	goal.connect("updated",self,"update_time")
func update_time():
	var msecs_now = Global.from_text(Time.get_time_string_from_system())
	#for subsecond precision, sucks I know
	var seconds = Time.get_unix_time_from_system()
	msecs_now += int(seconds*1000.0)%1000
	var msecs_remaining = msecs_now + remainder.msec
	text = Global.to_text_wrap_hours(msecs_remaining)
