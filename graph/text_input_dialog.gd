extends AcceptDialog
tool
signal submit(value)


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
export var value := "" setget set_value
signal value_changed(value)
signal value_updated()
func set_value(val):
	set_value_no_signal(val)
	emit_signal("value_changed", val)
	emit_signal("value_updated")
func set_value_no_signal(val):
	value = val
	if is_inside_tree():
		set_value_nodes()
func set_value_nodes():
	value_node.text = value

func _ready():
	set_value(value)
	set_label(label)
	connect("confirmed", self, "confirm")

func confirm():
	emit_signal("submit", value)
	
