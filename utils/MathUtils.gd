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

# inverts a conventional min-to-max range so that
# invert_range(b, n, s) == range(b, n, s).invert()
# b must be lower than n, otherwise they will be swapped
# b: min value (will be swapped with n if not)
# n: max value (will be swapped with b if not)
# s: step (assumed positive, will be inverted)
# invert_range(3) = [2, 1, 0]
# invert_range(1) = [0]
# invert_range(1, 3) = [2, 1]
# invert_range(1, 10, 3) = [7, 4, 1]
# invert_range(2, 8, 2) = [6, 4, 2]
# invert_range(2, 7, 2) = [6, 4, 2]

static func invert_range(b: int, n := 0, s := 1):
	if n < b:
		var aux := n
		n = b
		b = aux
	var end := n-1
	return range(end - (end - b)%s, b-s, -s)
