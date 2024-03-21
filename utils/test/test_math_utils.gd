extends Node

const INVERT_RANGE_INPUTS = [
		[3],
		[2],
		[1],
		[0, 5, 1],
		[2, 7, 2],
		[2, 8, 2],
		[1, 10, 3],
		[10, 16, 3],
		[-4, 8, 1],
		[-4, 8, 2],
		[-4, 9, 2]
	]
func padr(s, c := " "):
	return StringUtils.padr(str(s), 50, c)
func invert_range(input: Array):
	var res
	var expected
	var msg = "invert_range(%s)" % (("%2d"+", %2d".repeat(input.size()-1)) % input)
	match input:
		[var a]:
			res = MathUtils.invert_range(a)
			expected = range(a)
		[var a, var b]:
			res = MathUtils.invert_range(a, b)
			expected = range(a, b)
		[var a, var b, var c]:
			res = MathUtils.invert_range(a, b, c)
			expected = range(a, b, c)
	expected.invert()
	prints(padr(msg), "=", padr(res), "OK" if res == expected else ("!="+str(expected)))
	assert(res == expected, "%s != %s" % [res, expected])

func test_invert_range():
	print_begin("MathUtils.invert_range(b: int, n: int, s: int)")
	for input in INVERT_RANGE_INPUTS:
		invert_range(input)
	print_end()
	

const WRAPPED_RANGE_DATASET = [
	[[5,  0,  0,  1],  [0, 1, 2, 3, 4]],
	[[5,  1,  4,  1],  [1, 2, 3]],
	[[5,  2,  1,  1],  [2, 3, 4, 0]],
	[[5, -2,  0,  1],  [3, 4]],
	[[5, -2, -4,  1],  [3, 4, 0]],
	[[5,  0,  0, -1],  [0, 4, 3, 2, 1]],
	[[5, -1, -1, -1],  [4, 3, 2, 1, 0]],
	[[5,  2,  1,  2],  [2, 4]],
	[[5,  2,  1,  3],  [2, 0]],
	[[5,  2,  2,  4],  [2, 1]],
	[[5,  1,  2, -2],  [1, 4]],
	[[5,  1,  2, -3],  [1, 3]],
	[[5,  1,  2, -4],  [1]],
	[[5,  1,  1, -4],  [1, 2]]
]
func test_wrapped_range_(input:Array, expected:Array):
	var res = callv("wrapped_range", input)
	var call = "wrapped_range(%d, %2d, %2d, %2d)" % input
	assert(res == expected, " ".join([call, "=", str(res), "does not equal", str(expected)]))
	prints(padr(call), "=", padr(expected), "OK")
	
func wrapped_range(a, b, c, d):
	return MathUtils.wrapped_range(a,b,c,d)
func test_wrapped_range():
	print_begin("MathUtils.wrapped_range(size: int, begin: int, end: int, step: int)")
	for entry in WRAPPED_RANGE_DATASET:
		test_wrapped_range_(entry[0], entry[1])
	print_end()

func print_end():
	print("DONE\n")
func print_begin(test_name):
	print("TESTING ",test_name)

func _ready():
	test_invert_range()
	test_wrapped_range()
	get_tree().quit(0)
