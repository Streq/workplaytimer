extends Node
const Chronos = preload("res://utils/Chronos.gd")

var now_label : TimeLabel = null
func _ready():
	init()

func init():
	if !Groups.exists("now_label"):
		call_deferred("init")
		return
	now_label = Groups.get_one("now_label")
	owner.connect("process_changed", self, "_process_changed")
	now_label.connect("msec_changed", self, "update_msec")
	
	_process_changed(owner.is_processing())

func _process_changed(processing):
	get_parent().visible = processing

func update_msec(now_mil):
	var remaining_mil = owner.msec-owner.msec_done
	var finish_sec = (now_mil+remaining_mil)/1000
	get_parent().text = Chronos.sec_to_text_time_hhmmss(finish_sec)
