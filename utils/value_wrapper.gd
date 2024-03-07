"""
Wrapper for pass-by-value types, 
it doesn't actually check 
whether the value it holds is a reference or not, 
it just controls access to it.
"""

class_name ValueWrapper 
extends Reference

signal changed(new_value)
signal updated()
signal updated_internal()

var type : int
var value setget set_value

func _init(val):
	type = typeof(val)
	value = val

func set_value(val):
	set_value_no_signal(val)
	emit_signal("updated_internal")
	emit_signal("changed", value)
	emit_signal("updated")
	
func set_value_no_signal(val):
	assert(typeof(val) == typeof(value), "type mismatch")
	value = val
