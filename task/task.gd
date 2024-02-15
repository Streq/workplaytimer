extends PanelContainer
tool
signal updated()

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


onready var current_time = $"%current_time"
export var msec_progress := 0 setget set_msec_progress
func set_msec_progress(val):
	set_msec_progress_internal(val)
	if !is_inside_tree():
		return
	current_time.msec = msec
func set_msec_progress_internal(val):
	msec_progress = val
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
	if enabled:
		set_msec_done(0)
	else:
		set_msec_done(msec)
	_update_progress()
	emit_signal("updated")

export var msec_done := 0 setget set_msec_done
func set_msec_done(val):
	msec_done = val
	if !is_inside_tree():
		return
	progress.value = msec_done
	if msec_done >= msec:
		theme_type_variation = "selected"
		progress.update_look()
	else:
		theme_type_variation = ""
	

onready var remove = $"%remove"
onready var progress = $"%progress"

onready var selected_node = $"%selected"
export var selected := false setget set_selected
func set_selected(val):
	selected = val
	if !is_inside_tree():
		return
	_update_progress()
	if selected:
		hover_label.text = "unfocus"
	else:
		hover_label.text = "work on this"
		
export var selected_hovered := false setget set_selected_hovered
onready var hover_label = $"%hover_label"

func set_selected_hovered(val):
	selected_hovered = val
	if !is_inside_tree():
		return
	hover_label.visible = selected_hovered
	progress.percent_visible = !selected_hovered


func _ready():
	time_input.connect("msec_updated", self, "set_msec_internal")
	title_input.connect("text_changed", self, "set_title_internal")
	enabled_input.connect("toggled", self, "set_enabled_internal")
	remove.connect("pressed",self,"remove")
	selected_node.connect("toggled",self,"set_selected")
	selected_node.connect("mouse_entered", self, "set_selected_hovered", [true])
	selected_node.connect("mouse_exited", self, "set_selected_hovered", [false])
	set_title(title)
	set_msec(msec)
	set_msec_done(0)
	set_enabled(enabled)

func remove():
	set_enabled(false)
	queue_free()

func serialize():
	return {
		title = title,
		msec = msec,
		enabled = enabled
	}
func deserialize(dict):
	set_title(dict.title)
	set_msec(dict.msec)
	set_enabled(dict.enabled)

func _update_progress():
	if !is_inside_tree():
		return
	progress.value = msec_done
	progress.max_value = msec
	progress.focus = selected
	progress.visible = enabled and msec > 0
