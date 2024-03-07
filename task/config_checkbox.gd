extends CheckBox
export var prop := ""

func _ready():
	ConfigNode.find_config_and_connect(self, "initialize")

func initialize(config: ConfigMap):
	config.on_prop_change_notify_obj(prop, self, "_on_updated")
	connect("toggled", config, "set_property_rev", [prop])

func _on_updated(val):
	set_pressed_no_signal(val)
