extends Node
class_name DebugUtils

func _init():
	var msg = "%s is an utility class, you are not supposed to instantiate it." % get_script().resource_path
	assert(false, msg)
	printerr(msg)

static func print_debug(text):
	if OS.is_debug_build():
		print_debug(text)

static func print(text):
	if OS.is_debug_build():
		print(text)
