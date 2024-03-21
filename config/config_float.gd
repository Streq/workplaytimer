extends PanelContainer
tool

onready var label_node = $"%label"
export var label := "" setget set_label
signal label_changed(label)
signal label_updated()
func set_label(val):
	set_label_no_signal(val)
	emit_signal("label_changed", val)
	emit_signal("label_updated")
func set_label_no_signal(val):
	label = val
	if is_inside_tree():
		set_label_nodes()
func set_label_nodes():
	label_node.text = label

onready var value_node = $"%line_edit"
export var value : float = 0.0 setget set_value, get_value
signal value_changed(value)
signal value_updated()
func get_value() -> float:
	return value
func set_value(val : float):
	if value != val:
		set_value_no_signal(val)
		emit_signal("value_changed", get_value())
		emit_signal("value_updated")
func set_value_no_signal(val: float):
	value = val
	if is_inside_tree():
		set_value_nodes()
func set_value_nodes():
	value_node.value = get_value()

func _ready():
	set_value_no_signal(value)
	set_label_no_signal(label)
	value_node.connect("value_changed", self, "set_value")
	value_node.connect("focus_exited", self, "update_value")
func update_value():
	set_value(value_node.value)
