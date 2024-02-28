extends PanelContainer

signal submit()

const TaskPanel = preload("res://task/task_panel.gd")

var play_timer : TimeLabel
var task_panel : TaskPanel

onready var title = $"%title"
onready var time = $"%time"
onready var remainder = $"%remainder"
onready var transfer_all_checkbox = $"%transfer_all"
onready var time_container = $"%time_container"

onready var submit = $"%submit"

func initialize():
	submit.connect("pressed", self, "_submit")
	play_timer.connect("msec_changed", self, "_on_msec_changed")
	time.connect("msec_updated", self, "_on_msec_changed")
	transfer_all_checkbox.connect("toggled", self, "_on_transfer_all_toggled")
	_on_transfer_all_toggled(transfer_all_checkbox.pressed)
func _on_transfer_all_toggled(val):
	time_container.visible = !val

func _submit():
	time.update_msec()
	var accum = play_timer.msec
	var transfer_all = transfer_all_checkbox.pressed
	
	var time_to_transfer = accum if transfer_all else MathUtils.clampi(time.msec, 0, accum)
	
	play_timer.set_msec(accum-time_to_transfer)
	task_panel.register_work(title.text, time_to_transfer)
	emit_signal("submit")

func _on_msec_changed(_val=0):
	if time.msec > play_timer.msec:
		time.set_msec_internal(play_timer.msec)
	remainder.set_msec(play_timer.msec-time.msec)
	
