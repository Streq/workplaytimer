extends Node
const Chronos = preload("res://utils/Chronos.gd")

var now_label : TimeLabel = null
func _ready():
	init()

func init():
	if !Groups.exists("now_label"):
		get_tree().connect("idle_frame", self, "init", [], CONNECT_ONESHOT)
		return
	now_label = Groups.get_one("now_label")
	owner.connect("process_changed", self, "_process_changed")
	get_parent().connect("draw", self, "draw")
	_process_changed(owner.is_processing())

func _process_changed(processing):
	SignalUtils.connect_(now_label, processing, "updated", get_parent(), "update")
	get_parent().visible = processing

func draw():
	var now_mil = now_label.msec
	var remaining_mil = owner.msec-owner.msec_done
	var finish_sec = (now_mil+remaining_mil)/1000
	get_parent().text = Chronos.sec_to_text_time_hhmmss(finish_sec)

	pass
