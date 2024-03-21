extends Node

var config : ConfigMap 

func _ready():
	ConfigNode.find_config_and_connect(self, "initialize")

func initialize(config: ConfigMap):
	self.config = config

func frame():
	if OS.window_minimized:
		minimized()
	elif !OS.is_window_focused():
		low_process()
	else:
		high_process()

func high_process():
	owner.show()
	var vp := get_tree().root
	vp.render_target_update_mode = Viewport.UPDATE_WHEN_VISIBLE
	OS.low_processor_usage_mode = false

func low_process():
	owner.show()
	var vp := get_tree().root
	vp.render_target_update_mode = Viewport.UPDATE_WHEN_VISIBLE
	OS.low_processor_usage_mode_sleep_usec = 100_000
	OS.low_processor_usage_mode = true
	
func minimized():
	owner.hide()
	var vp := get_tree().root
	vp.render_target_update_mode = Viewport.UPDATE_DISABLED
	OS.low_processor_usage_mode_sleep_usec = 500_000
	OS.low_processor_usage_mode = true
