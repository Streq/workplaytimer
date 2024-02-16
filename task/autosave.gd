extends Timer
signal triggered()

export var enabled := true

#timer that saves progress every N seconds
func trigger():
	if enabled and self.is_stopped():
		start()

func _ready():
	if Engine.editor_hint:
		return
	add_to_group("autosave")
	connect("timeout", self, "_on_timeout")
	var authority = Groups.get_one("autosave_authority")
	if is_instance_valid(authority):
		enabled = authority.should_autosave
func _on_timeout():
	emit_signal("triggered")

func enable():
	enabled = true
func disable():
	enabled = false
