extends PanelContainer

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
onready var components = $"%components"

var add_queue = []
func add_child(node, is_legible_name := false):
	if !is_inside_tree():
		add_queue.append([node, is_legible_name])
		return
	components.add_child(node, is_legible_name)

func _ready():
	set_label_no_signal(label)
	for call in add_queue:
		var node = call[0]
		var is_legible = call[1]
		if is_instance_valid(node):
			add_child(node, is_legible)
	add_queue.clear()
