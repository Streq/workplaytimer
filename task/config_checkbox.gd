extends CheckBox
export var prop := ""

onready var config : Config = $"%config"
func _ready():
	config.notify_on_init(self, "initialize")

func initialize():
	config.file.connect(prop+"_updated", self, "_on_updated")
	connect("toggled", self, "_on_toggled")
func _on_updated(val):
	set_pressed_no_signal(val)
func _on_toggled(val):
	config.file.set_property(prop, val)
