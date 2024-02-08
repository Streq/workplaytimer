extends TimeLabel

export var goal_path : NodePath
onready var goal = get_node(goal_path)
export var timer_path : NodePath
onready var timer = get_node(timer_path)

func _ready() -> void:
	if Engine.editor_hint:
		return
	._ready()
	timer.connect("updated",self,"render_text")
	goal.connect("updated",self,"render_text")
func render_text() -> void:
	if !goal:
		yield(self,"ready")
	set_msec(goal.msec - timer.msec)
	set_text(Global.to_text(msec))
