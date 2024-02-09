extends ProgressBar


export var goal_path : NodePath
onready var goal : TimeLabel  = get_node(goal_path)
export var timer_path : NodePath
onready var timer : TimeLabel = get_node(timer_path)

func _ready():
	yield(owner,"ready")
	timer.connect("updated",self,"update_progress")

func update_progress():
	var target = goal.msec
	var current = timer.msec
	if target > 0:
		ratio = clamp(float(current) / float(target), 0.0, 1.0)
