extends TextEdit

export var goal_path : NodePath
onready var goal = get_node(goal_path)
export var timer_path : NodePath
onready var timer = get_node(timer_path)

var msec = 0

func _ready() -> void:
	timer.connect("updated",self,"render_text")
	goal.connect("updated",self,"render_text")
func render_text() -> void:
	msec = (goal.goal_msecs - timer.accumulated_time_msec)
	text = Global.to_text(msec)
