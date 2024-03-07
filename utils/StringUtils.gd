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

static func wrap_line(tooltip: String, max_length : int) -> String:
	var regex := RegEx.new() 
	regex.compile("\\S+") # non whitespace text
	var results := regex.search_all(tooltip)
	var ret := ""
	var line_length := 0
	
	for r in results:
		var result : RegExMatch = r
		var word : String = result.get_string()
		var text_to_add : String
		if line_length == 0:
			text_to_add = word
		elif line_length + word.length()+1 > max_length:
			ret += "\n"
			line_length = 0
			text_to_add = word
		else:
			text_to_add = " " + word

		ret += text_to_add
		line_length += text_to_add.length()
		
	return ret
