class_name StringBuilder extends Reference

var arr := PoolStringArray()
var size := 0
var capacity := 0

func _init(initial_size := 0, initial_capacity := 0):
	set_capacity(initial_capacity)
	set_size(initial_size)

func set_size(n: int):
	reserve(size)
	size = n

# ensures it has memory for at least n entries
func reserve(n: int):
	if capacity <= self.capacity:
		return
	set_capacity(n)

# ensures it has memory for exactly n entries
func truncate(n := 0):
	set_capacity(n)

func set_capacity(val: int):
	arr.resize(val)
	size = min(size, val)
	capacity = val

func get_index(index: int):
	assert(index < size and -size-1 < index, "index out of bounds")
	return posmod(index, size)

func at(index: int) -> String:
	return arr[get_index(index)]

func _to_string() -> String:
	return "StringBuffer(%s)" % str(arr)

func to_string() -> String:
	return arr.join("")

func write(src: StringBuilder, at_index := 0, src_index := 0, size := -1):
	at_index = get_index(at_index)
	src_index = src.get_index(src_index)
	if size < 0:
		size = src.size
	if at_index + size > self.size:
		set_size(at_index + size)
	
	for i in size:
		arr.set(at_index + i, src.at(src_index + i))
func append(src: StringBuilder, src_index := 0, size := -1):
	src_index = posmod(src_index, src.size)
	
	if size < 0:
		size = src.size
	
	set_size(self.size + size)
	for i in range(src_index, src_index+size):
		arr.set(i, src.at(i))

func write_str(src: String, at_index := 0):
	
	at_index = posmod(at_index, self.size)
	
	var size = src.length()
	if at_index + size > self.size:
		reserve(at_index + size)

	for i in size:
		arr.set(i, src[i])
