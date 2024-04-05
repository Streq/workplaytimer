extends Node
class_name StringUtils
func _init():
	var msg = "%s is an utility class, you are not supposed to instantiate it." % get_script().resource_path
	assert(false, msg)
	printerr(msg)

# pad right, assumes s is a single character
static func padr(text:String, to_length:int, pad := " ") -> String:
	if text.length() >= to_length:
		return text
	return text + pad.repeat(to_length - text.length())

# pad left, assumes s is a single character
static func padl(text:String, to_length:int, pad := " ") -> String:
	if text.length() >= to_length:
		return text
	return pad.repeat(to_length - text.length()) + text

# pad center left, assumes s is a single character
static func padcl(text:String, to_length:int, pad := " ") -> String:
	if text.length() >= to_length:
		return text
	var remainder = to_length - text.length()
	return pad.repeat(remainder/2) + text + pad.repeat(remainder/2) + pad.repeat(remainder%2)

# pad center right, assumes s is a single character
static func padcr(text:String, to_length:int, pad := " ") -> String:
	if text.length() >= to_length:
		return text
	var remainder = to_length - text.length()
	return pad.repeat(remainder%2) + pad.repeat(remainder/2) + text + pad.repeat(remainder/2)

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

#
#static func wrap_text_performant(text: String, line_length : int) -> String:
#	var length = text.length()
#
#	var ret := PoolStringArray()
#	ret.resize(length*2) # text will never be longer than this
#	var ret_write_cursor := -1
#
#	var word_buffer := PoolStringArray()
#	word_buffer.resize(line_length) # words longer than line_length get hyphenated
#	var word_buffer_write_cursor := 0
#
#	var current_line_length := 0
#
#	for character in text:
#		ret_write_cursor += 1
#		match character:
#			" ", "\t":
#				if current_line_length > line_length:
#					pass
#			"\n":
#				current_line_length = 0
#			_:
#				if word_buffer_write_cursor == line_length:
#					pass
#				word_buffer[word_buffer_write_cursor] = character
#				word_buffer_write_cursor += 1
##				if word_buffer:
#				current_line_length += 1
#
#		prints(ret.join(""))
#
#
#	return ""
	
