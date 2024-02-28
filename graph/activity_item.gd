extends HBoxContainer


onready var label_node = $"%Label"
var label := "" setget set_label
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


onready var color_picker_button = $"%color_picker_button"
var color := Color.white setget set_color
signal color_changed(color)
signal color_updated()
func set_color(val):
	set_color_no_signal(val)
	emit_signal("color_changed", val)
	emit_signal("color_updated")
func set_color_no_signal(val):
	color = val
	if is_inside_tree():
		set_color_nodes()
func set_color_nodes():
	pass
#	color_picker_button.set_color(color)


onready var show_node = $"%show"
signal show_changed(show)
signal show_updated()
var show := true setget set_show
func set_show(val):
	set_show_no_signal(val)
	emit_signal("show_changed", val)
	emit_signal("show_updated")
func set_show_no_signal(val):
	show = val
	if is_inside_tree():
		set_show_nodes()
func set_show_nodes():
	show_node.set_pressed_no_signal(show)


onready var single_node = $"%single"
var single := false setget set_single
signal single_changed(single)
signal single_updated()
func set_single(val):
	set_single_no_signal(val)
	emit_signal("single_changed", val)
	emit_signal("single_updated")
func set_single_no_signal(val):
	single = val
	if is_inside_tree():
		set_single_nodes()
func set_single_nodes():
	single_node.set_pressed_no_signal(single)

func _on_single_node_toggled(val):
	set_single(val)
	if val:
		set_show(true)
func _on_show_node_toggled(val):
	set_show(val)
	if !val:
		set_single(false)

func _ready():
	single_node.connect("toggled", self, "_on_single_node_toggled")
	show_node.connect("toggled", self, "_on_show_node_toggled")
		
	set_single_nodes()
	set_color_nodes()
	set_show_nodes()
	set_label_nodes()
