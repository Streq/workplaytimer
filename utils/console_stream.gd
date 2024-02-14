extends RichTextLabel

const PRINT_FORMAT = "%s\n"
const DEBUG_BBCODE = "[color=yellow]%s[/color]"
const ERR_BBCODE = "[color=red]● %s[/color]"

func _ready():
	Console.connect("printed", self, "_on_printed")
	Console.connect("printed_debug", self, "_on_printed_debug")
	Console.connect("printed_err", self, "_on_printed_err")
	Console.connect("printed_stack", self, "_on_printed_stack")
	connect("meta_clicked", self, "_on_meta_clicked")

func _on_printed(val):
	var line = format(val)
	append_bbcode(line)

func _on_printed_debug(val):
	var line = format(DEBUG_BBCODE % val)
	
	append_bbcode(line)
func _on_printed_err(val):
	var line = format(ERR_BBCODE % val)
	append_bbcode(line)

func _on_printed_stack(val):
	var line = format(val)
	append_bbcode(line)

func format(val):
	return PRINT_FORMAT % val


func _on_meta_clicked(meta):
	if meta is String:
		OS.shell_open(meta)
