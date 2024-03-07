extends LineEdit
signal changed(val)
func _ready() -> void:
	ConfigNode.find_config_and_connect(self, "initialize")
	
func initialize(config : ConfigMap) -> void:
	config.on_prop_change_notify_obj("interval", self, "set_interval_internal")
	config.on_obj_signal_modify_prop("interval", self, "changed")
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
		emit_signal("changed", interval)
		
func text_changed(val:String):
	set_interval(val.to_float())
