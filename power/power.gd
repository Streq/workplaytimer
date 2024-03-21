extends Node

var config : ConfigMap 

var unfocus_enabled := ValueWrapper.new(false)
var unfocus_sleep := ValueWrapper.new(int(100))
var unfocus_render := ValueWrapper.new(true)

var minimized_enabled := ValueWrapper.new(false)
var minimized_sleep := ValueWrapper.new(int(100))
var minimized_render := ValueWrapper.new(false)


func _ready():
	ConfigNode.find_config_and_connect(self, "initialize")

func initialize(config: ConfigMap):
	config.on_prop_change_notify_obj("low_process_on_unfocus/enabled", unfocus_enabled, "set_value")
	config.on_prop_change_notify_obj("low_process_on_unfocus/sleep_milliseconds", unfocus_sleep, "set_value")
	config.on_prop_change_notify_obj("low_process_on_unfocus/render", unfocus_render, "set_value")

	config.on_prop_change_notify_obj("low_process_on_minimized/enabled", minimized_enabled, "set_value")
	config.on_prop_change_notify_obj("low_process_on_minimized/sleep_milliseconds", minimized_sleep, "set_value")
	config.on_prop_change_notify_obj("low_process_on_minimized/render", minimized_render, "set_value")

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
	if !unfocus_enabled.value:
		high_process()
		return
	owner.visible = unfocus_render.value
	var vp := get_tree().root
	vp.render_target_update_mode = Viewport.UPDATE_WHEN_VISIBLE
	OS.low_processor_usage_mode_sleep_usec = unfocus_sleep.value * 1000
	OS.low_processor_usage_mode = true
	
func minimized():
	if !minimized_enabled.value:
		high_process()
		return
	owner.visible = minimized_render.value
	var vp := get_tree().root
	vp.render_target_update_mode = Viewport.UPDATE_DISABLED
	OS.low_processor_usage_mode_sleep_usec = minimized_sleep.value * 1000
	OS.low_processor_usage_mode = true
	
