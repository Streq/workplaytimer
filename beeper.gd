extends Node


func _ready():
	ConfigNode.find_config_and_connect(self, "initialize")

func initialize(config: ConfigMap):
	config.on_prop_change_notify_obj("interval", self, "set_interval")
	get_tree().connect("idle_frame", self, "hook", [], CONNECT_ONESHOT)

func hook():
	owner.connect("updated", self, "check")


func check():
	if !get_parent().sound_on or !owner.is_processing():
		return

	var ms_before = owner.msec_before
	var ms_now = owner.msec

	if !ms_before:
		return

	var prev_tic = ms_before/MS_PER_TIC
	var curr_tic = ms_now/MS_PER_TIC

	if prev_tic != curr_tic:
		get_parent().play()

var MS_PER_TIC = 1000
func set_interval(val:float):
	var ms = int(val*1000.0)
	if ms > 0:
		MS_PER_TIC = ms
