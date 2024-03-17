extends Node
class_name SignalUtils

func _init():
	var msg = "%s is an utility class, you are not supposed to instantiate it." % get_script().resource_path
	assert(false, msg)
	printerr(msg)

static func connect_(entity: Object, do_connect: bool, signal_name: String, target: Object, method: String, binds:= [], flags:= 0) -> int:
	if do_connect:
		if !entity.is_connected(signal_name, target, method):
			return entity.connect(signal_name, target, method, binds, flags)
	else:
		if entity.is_connected(signal_name, target, method):
			entity.disconnect(signal_name, target, method)
	return 0
