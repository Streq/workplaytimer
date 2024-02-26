extends Node
class_name MathUtils

func _init():
	var msg = "%s is an utility class, you are not supposed to instantiate it." % get_script().resource_path
	assert(false, msg)
	printerr(msg)

static func clampi(val:int, min_val:int, max_val:int) -> int:
	return maxi(min_val, mini(max_val, val))
static func maxi(val:int, val2:int) -> int:
	return val if val > val2 else val2
static func mini(val:int, val2:int) -> int:
	return val if val < val2 else val2
