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

onready var remove = $"%remove"
onready var progress = $"%progress"

func _ready():
	time_input.connect("msec_updated", self, "set_msec_internal")
	title_input.connect("text_changed", self, "set_title_internal")
	enabled_input.connect("toggled", self, "set_enabled_internal")
	remove.connect("pressed",self,"remove")
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
	progress.visible = enabled and msec > 0
