extends LineEdit


func _ready() -> void:
	yield(owner,"ready")
	owner.config.connect("interval_updated",self,"set_interval_internal")
	connect("text_changed", self, "text_changed")

var interval : float = 1.0 setget set_interval
	
func set_interval_internal(val: float):
	if val <= 0.0 or val == interval:
		return
	interval = val
	var old_caret_position = caret_position
	text = str(val)
	caret_position = old_caret_position


func set_interval(val):
	var old = interval
	set_interval_internal(val)
	var new = interval
	if old != new:
		owner.config.set_property("interval",interval)

func text_changed(val:String):
	set_interval(val.to_float())
