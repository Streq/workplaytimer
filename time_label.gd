extends Control
class_name TimeLabel
tool

signal updated
signal started
signal stopped

var msec := 0
var msec_before := 0
export var stopped := false
export var color : Color = Color.aquamarine setget set_color

func set_msec(val):
	msec_before = msec
	msec = val

func set_color(val):
	color = val
	if !label:
		yield(self, "ready")
	label.add_color_override("font_color",color)
	title_label.add_color_override("font_color",color)
	description_label.add_color_override("font_color",color)

onready var title_label = $"%title"
export var title := "Work" setget set_title
func set_title(val):
	title = val
	if !title_label:
		yield(self, "ready")
	title_label.text = val

onready var description_label = $"%description"
export var description:= "jaja" setget set_description
func set_description(val):
	description = val
	if !description_label:
		yield(self, "ready")
	description_label.text = val

onready var label : LineEdit = $"%label"
export var text := "00:00:00" setget set_text
func set_text(val):
	if !val:
		val = ""
	text = val
	if !label:
		yield(self, "ready")
	label.text = val
	emit_signal("updated")

onready var config = $"%config"

func _ready() -> void:
	if Engine.editor_hint:
		return
	yield(get_tree(),"idle_frame")
	config.initialize()
	set_stopped(stopped)
	set_color(color)
	render_text()
	label.connect("text_entered",self,"_on_text_entered")
	label.connect("text_changed",self,"_on_text_changed")

func render_text():
	set_text(Global.to_text(msec))

func set_stopped(val):
	stopped = val
	if stopped:
		off()
	else:
		on()


func switch():
	if stopped:
		on()
	else:
		off()

func on():
	stopped = false
	update_process()
func off():
	stopped = true
	update_process()
func _on_text_entered(new_text := ""):
	msec = Global.from_text(label.text)
	render_text()
func _on_text_changed(new_text := ""):
	msec = Global.from_text(label.text)
	emit_signal("updated")
	
func _start():
	pass
func _stop():
	pass

var frozen = false
func set_frozen(val):
	if val:
		freeze()
	else:
		unfreeze()
func freeze():
	frozen = true
	update_process()
func unfreeze():
	frozen = false
	update_process()

func update_process():
	var process = !frozen and !stopped
	set_process(process)
	if !process:
		emit_signal("stopped")
		_stop()
	else:
		emit_signal("started")
		_start()
