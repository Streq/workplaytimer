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
