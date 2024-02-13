extends HBoxContainer
tool
onready var _label_node = $label
onready var _value_node = $value

# value
export var value : String setget set_value
func set_value(val):
	value = val if val else ""
	if !is_inside_tree():
		return
	_update_value()
func _update_value():
	_value_node.text = value

# label
export var label : String setget set_label 
func set_label(val):
	label = val
	if !is_inside_tree():
		return
	_update_label()
func _update_label():
	_label_node.text = label

# editable
export var editable : bool = true setget set_editable
func set_editable(val):
	editable = val
	if !is_inside_tree():
		return
	_update_editable()
func _update_editable():
	_value_node.editable = editable


func _ready():
	_update_label()
	_update_value()
	_update_editable()
	_value_node.connect("text_changed", self, "_on_value_node_text_changed")
func _on_value_node_text_changed(val):
	value = val
