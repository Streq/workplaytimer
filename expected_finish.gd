extends TimeLabel
tool

export var remainder_path : NodePath
onready var remainder = get_node(remainder_path)
export var timer_path : NodePath
onready var timer = get_node(timer_path)
export var goal_path : NodePath
onready var goal = get_node(goal_path)
export var now_path : NodePath
onready var now = get_node(now_path)


func _process(delta: float) -> void:
	if Engine.editor_hint:
		return
	update_time()

func _ready() -> void:
	if Engine.editor_hint:
		return
	._ready()
	timer.connect("started",self,"set_process",[false])
	timer.connect("stopped",self,"set_process",[true])
	goal.connect("updated",self,"update_time")
	
func update_time():
	set_text(Global.to_text_wrap_hours(now.msec + remainder.msec))
