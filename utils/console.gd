extends Node

signal printed(text)
signal printed_err(text)
signal printed_debug(text)
signal printed_stack(text)

const STACK_FRAME = "Frame {i} - {source}:{line} in function '{function}'\n"

func do_print(text):
	print(text)
	emit_signal("printed", text)
func do_printerr(text):
	printerr(text)
	emit_signal("printed_err", text)
func do_print_debug(text):
	if !OS.is_debug_build():
		return
	print_debug(text)
	var frame = get_stack()[1]
	var debug_text = "{text}\n\tAt: {source}:{line}:{function}()".format({
			"text":text, 
			"source":frame.source,
			"line":frame.line,
			"function":frame.function
		})
	emit_signal("printed_debug", debug_text)

func do_print_stack():
	var stack = get_stack()
	
	var text = ""
	# ignore first frame since it's this function
	for i in range(1, stack.size()):
		var frame = stack[i]
		text += STACK_FRAME.format({
				"i": i-1, 
				"source": frame.source, 
				"line": frame.line, 
				"function": frame.function
			})
	print(text)
	emit_signal("printed_stack", text)
