extends ColorRect
func _ready():
	connect("visibility_changed",self,"_on_visibility_changed")
func _on_visibility_changed():
	set_process(visible)
