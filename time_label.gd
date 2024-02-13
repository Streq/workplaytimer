extends Control
class_name TimeLabel
tool

signal updated
signal started
signal stopped

onready var SAVE_PATH = Global.PATH.plus_file("state").plus_file(name+".json") 
onready var title_label = $"%title"
onready var description_label = $"%description"
onready var label : LineEdit = $"%label"
onready var config = $"%config"

export var stopped := false
export var color : Color = Color.white setget set_color
func set_color(val):
	color = val
	if !is_inside_tree():
		return
	_update_color()
func _update_color():
	label.add_color_override("font_color", color)
	title_label.add_color_override("font_color", color)
	description_label.add_color_override("font_color", color)


export var title : String = "title" setget set_title
func set_title(val):
	title = val
	if !is_inside_tree():
		return
	_update_title()
func _update_title():
	title_label.text = title

export var description : String = "description" setget set_description
func set_description(val):
	description = val
	if !is_inside_tree():
		return
	_update_description()
func _update_description():
	description_label.text = description

export var text : String = "-" setget set_text
func set_text(val):
	text = val if val else ""
	if !is_inside_tree():
		return
	_update_text(val)
func _update_text(val):
	label.text = val
	emit_signal("updated")


var msec := 0
var msec_before := 0
func set_msec(val):
	msec_before = msec
	msec = val


func _ready() -> void:
	_update_title()
	_update_description()
	_update_color()
	render_text()
	if Engine.editor_hint:
		return
	config.initialize()
	set_stopped(stopped)
	label.connect("text_entered", self, "_on_text_entered", [true])
	label.connect("text_changed", self, "_on_text_changed", [true])

func save():
	FileUtils.save_json_file(SAVE_PATH, {"msec":msec})
func load_():
	var save_state = FileUtils.load_json_file_as_dict(SAVE_PATH)
	if save_state != null and "msec" in save_state:
		msec = save_state.msec
	render_text()

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
func _on_text_entered(_new_text := "", save:=false):
	msec = Global.from_text(label.text)
	render_text()
	if save:
		save()
func _on_text_changed(_new_text := "", save:=false):
	msec = Global.from_text(label.text)
	var caret = label.caret_position
	emit_signal("updated")
	label.caret_position = caret
	if save:
		save()
	
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
