extends Object
class_name MapUtils
func _init():
	var msg = "%s is an utility class, you are not supposed to instantiate it." % get_script().resource_path
	assert(false, msg)
	printerr(msg)


static func put_if_absent(map: Dictionary, key, value):
	value = map.get(key, value)
	map[key] = value
	return value
