extends Node
class_name StringUtils
func _init():
	var msg = "%s is an utility class, you are not supposed to instantiate it." % get_script().resource_path
	assert(false, msg)
	printerr(msg)

# pad right, assumes s is a single character
static func padr(text:String, to_length:int, pad := " "):
	if text.length() >= to_length:
		return text
	return text + pad.repeat(to_length - text.length())

# pad left, assumes s is a single character
static func padl(text:String, to_length:int, pad := " "):
	if text.length() >= to_length:
		return text
	return pad.repeat(to_length - text.length()) + text

# horrible efficiency-wise but works
static func wrap_string(string: String, max_length : int) -> String:
	var ret := ""
	for l in string.split("\n"):
		var line : String = l
		ret += wrap_line(line, max_length) + "\n"
	return ret

# assumes line to have no '\n' 
static func wrap_line(line: String, max_length : int) -> String:
	var results := Regex.NON_WHITESPACE.search_all(line)
	var ret := ""
	var line_length := 0
	
	for r in results:
		var result : RegExMatch = r
		var word : String = result.get_string()
		var connector : String
		# start of line
		if line_length == 0:
			connector = ""
		# not start of line and within line length
		elif line_length + word.length()+1 <= max_length: 
			connector = " "
		# not start of line and past line length
		else:
			connector = "\n"
			line_length = 0
			
		ret += connector + word
		line_length += connector.length() + word.length()
		
	return ret


class StringBuffer:
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

	func write(src: StringBuffer, at_index := 0, src_index := 0, size := -1):
		at_index = get_index(at_index)
		src_index = src.get_index(src_index)
		if size < 0:
			size = src.size
		if at_index + size > self.size:
			set_size(at_index + size)
		
		for i in size:
			arr.set(at_index + i, src.at(src_index + i))
	func append(src: StringBuffer, src_index := 0, size := -1):
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

static func wrap_text_performant(text: String, line_length : int) -> String:
	var length = text.length()
	
	var ret := PoolStringArray()
	ret.resize(length*2) # text will never be longer than this
	var ret_write_cursor := -1
	
	var word_buffer := PoolStringArray()
	word_buffer.resize(line_length) # words longer than line_length get hyphenated
	var word_buffer_write_cursor := 0
	
	var current_line_length := 0
	
	for character in text:
		ret_write_cursor += 1
		match character:
			" ", "\t":
				if current_line_length > line_length:
					pass
			"\n":
				current_line_length = 0
			_:
				if word_buffer_write_cursor == line_length:
					pass
				word_buffer[word_buffer_write_cursor] = character
				word_buffer_write_cursor += 1
#				if word_buffer:
				current_line_length += 1
		
		prints(ret.join(""))
		
	
	return ""
	
