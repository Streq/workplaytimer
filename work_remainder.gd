extends TimeLabel
tool

export var goal_path : NodePath
onready var goal = get_node(goal_path)
export var timer_path : NodePath
onready var timer = get_node(timer_path)

func _ready() -> void:
	if Engine.editor_hint:
		return
#	._ready()
	timer.connect("updated",self,"update_text")
	goal.connect("updated",self,"update_text")

func update_text():
	var dif = goal.msec - timer.msec
	set_msec(dif)
	render_text()
