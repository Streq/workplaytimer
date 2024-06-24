extends Node
tool
class_name MathUtils

func _init():
	var msg = "%s is an utility class, you are not supposed to instantiate it." % get_script().resource_path
	assert(false, msg)
	printerr(msg)

static func clampi(val: int, min_val: int, max_val: int) -> int:
	return maxi(min_val, mini(max_val, val))
static func maxi(val: int, val2: int) -> int:
	return val if val >= val2 else val2
static func mini(val: int, val2: int) -> int:
	return val if val <= val2 else val2
static func signi(val: int) -> int:
	return clampi(val, -1, 1)
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

static func invert_range(b: int, n: = 0, s: = 1):
	if n < b:
		var aux := n
		n = b
		b = aux
	var end := n-1
	return range(end - (end - b)%s, b-s, -s)

# wrapped_range(5,  0,  0,  1) = [0, 1, 2, 3, 4]
# wrapped_range(5,  1,  4,  1) = [1, 2, 3]
# wrapped_range(5,  2,  1,  1) = [2, 3, 4, 0]
# wrapped_range(5, -2,  0,  1) = [3, 4]
# wrapped_range(5, -2, -4,  1) = [3, 4, 0]
# wrapped_range(5,  0,  0, -1) = [0, 4, 3, 2, 1]
# wrapped_range(5, -1, -1, -1) = [4, 3, 2, 1, 0]
# wrapped_range(5,  2,  1,  2) = [2, 4]
# wrapped_range(5,  2,  1,  3) = [2, 0]
# wrapped_range(5,  2,  2,  4) = [2, 1]
# wrapped_range(5,  1,  2, -2) = [1, 4]
# wrapped_range(5,  1,  2, -3) = [1, 3]
# wrapped_range(5,  1,  2, -4) = [1]
# wrapped_range(5,  1,  1, -4) = [1, 2]
static func wrapped_range(size: int, begin: = 0, end: = 0, step: = 1):
	begin = posmod(begin, size)
	end = posmod(end, size)
	if step == 0:
		return []
	if (step > 0 and begin < end) or (step < 0 and end < begin):
		return range(begin, end, step)
	
	var end_ = size if step > 0 else -1
	var step_remainder := posmod(begin-end_, step)
	return range(begin, end_, step) + range(size - signi(step)*end_ + step_remainder, end, step)

static func absi(n: int) -> int:
	return n if n > 0 else -n

static func is_between(c:int, s:int, e:int):
	return s <= c && c <= e
	
static func range_intersection(s: int, e: int, start: int, end: int) -> PoolIntArray:
	if e < start:
		return PoolIntArray([s, e, start, end])
	if s > end:
		return PoolIntArray([start, end, s, e])
	return PoolIntArray([mini(s, start), maxi(e, end)])
