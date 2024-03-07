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

func invert_range(input: Array):
	var res
	var expected
	var msg = "invert_range(%s) =" % ", ".join(input)
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
	prints(msg, res, "OK" if res == expected else ("!="+str(expected)))
	assert(res == expected, "%s != %s" % [res, expected])
	LineEdit.new()

func _ready():
	for input in INVERT_RANGE_INPUTS:
		invert_range(input)
	
	get_tree().quit(0)
