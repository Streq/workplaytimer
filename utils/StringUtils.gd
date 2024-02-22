extends Node

func _init():
	var msg = "%s is an utility class, you are not supposed to instantiate it." % get_script().resource_path
	assert(false, msg)
	printerr(msg)

#pad right, assumes s is a single character
static func padr(text:String, to_length:int, pad := " "):
	if text.length() >= to_length:
		return text
	return text + pad.repeat(to_length - text.length())

#pad left, assumes s is a single character
static func padl(text:String, to_length:int, pad := " "):
	if text.length() >= to_length:
		return text
	return pad.repeat(to_length - text.length()) + text
