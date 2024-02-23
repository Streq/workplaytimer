extends PanelContainer
tool
signal updated()
signal completed()
signal deleting()
signal process_changed(val)

const DeltaTimer = preload("res://utils/time/delta_timer.gd")

var dt := DeltaTimer.new()

const is_task = true


onready var title_input = $"%title"
export var title = "" setget set_title
func set_title(val):
	set_title_internal(val)
	if !is_inside_tree():
		return
	title_input.text = val
func set_title_internal(val):
	title = val

onready var time_input = $"%time_input"
export var msec := 0 setget set_msec
func set_msec(val):
	set_msec_internal(val)
	if !is_inside_tree():
		return
	time_input.msec = msec
func set_msec_internal(val):
	msec = val
	_update_progress()
	emit_signal("updated")


var completed = false

onready var current_time = $"%current_time"
export var msec_done := 0 setget set_msec_done
func set_msec_done(val):
	set_msec_done_internal(val)
	if !is_inside_tree():
		return
	if msec_done >= msec:
		if !completed:
			completed = true
			emit_signal("completed")
		theme_type_variation = "selected"
	else:
		completed = false
		theme_type_variation = ""
	current_time.set_msec_internal(msec_done)
	progress.value = msec_done
	progress.update_look()

func set_msec_done_internal(val):
	msec_done = val if val < msec else msec
	_update_progress()
	emit_signal("updated")
	
onready var enabled_input = $"%enabled"
export var enabled := true setget set_enabled
func set_enabled(val):
	set_enabled_internal(val)
	if !is_inside_tree():
		return
	enabled_input.pressed = val
func set_enabled_internal(val):
	enabled = val
	_update_can_process()
	_update_progress()
	emit_signal("updated")


onready var remove = $"%remove"
onready var progress = $"%progress"

onready var selected_node = $"%selected"
export var selected := false setget set_selected
func set_selected(val):
	set_selected_internal(val)
	if !is_inside_tree():
		return
	selected_node.pressed = val

func set_selected_internal(val):
	selected = val
	_update_can_process()
	
	if !is_inside_tree():
		return
	
	dt.get_and_reset()
	
	_update_progress()
	if selected:
		hover_label.text = "stop"
	else:
		hover_label.text = "start"	
	
export var selected_hovered := false setget set_selected_hovered
onready var hover_label = $"%hover_label"
func set_selected_hovered(val):
	selected_hovered = val
	if !is_inside_tree():
		return
	hover_label.visible = selected_hovered
	progress.percent_visible = !selected_hovered

export var paused := false setget set_paused
func set_paused(val):
	paused = val
	_update_can_process()

func _update_can_process():
	var new_val = selected and !paused and enabled
	if is_processing() != new_val:
		dt.get_and_reset()
		set_process(new_val)
		emit_signal("process_changed", new_val)

func _ready():
	add_to_group("task")
	time_input.connect("msec_updated", self, "set_msec_internal")
	current_time.connect("msec_updated", self, "set_msec_done_internal")
	title_input.connect("text_changed", self, "set_title_internal")
	enabled_input.connect("toggled", self, "set_enabled_internal")
	remove.connect("pressed",self,"remove")
	selected_node.connect("toggled",self,"set_selected_internal")
	selected_node.connect("mouse_entered", self, "set_selected_hovered", [true])
	selected_node.connect("mouse_exited", self, "set_selected_hovered", [false])
	set_title(title)
	set_msec(msec)
	set_msec_done(msec_done)
	set_enabled(enabled)
	set_selected(selected)

func remove():
	set_enabled(false)
	queue_free()
	emit_signal("deleting")
func serialize():
	return {
		title = title,
		msec = msec,
		msec_done = msec_done,
		enabled = enabled,
		selected = selected
	}
func deserialize(dictionary):
	if !dictionary:
		return
	var dict = serialize()
	dict.merge(dictionary, true)
	set_title(dict.title)
	set_msec(dict.msec)
	set_msec_done(dict.msec_done)
	set_enabled(dict.enabled)
	set_selected(dict.selected)

func _update_progress():
	if !is_inside_tree():
		return
	progress.value = msec_done
	progress.max_value = msec
	progress.focus = selected
	progress.visible = enabled and msec > 0

func _process(_delta):
	set_msec_done(msec_done + dt.get_and_reset())
