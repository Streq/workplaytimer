extends PopupMenu
const DIR = "res://assets/sfx/"
signal file_selected(file)
func _ready() -> void:
	ConfigNode.find_config_and_connect(self, "initialize")

var signals = []
func initialize(config : ConfigMap):
	populate()
	
	connect("index_pressed", self, "index_pressed")
	connect("about_to_show", self, "about_to_show")
	
	config.on_obj_signal_modify_prop("audio_file", self, "file_selected")
	config.on_prop_change_notify_obj("audio_file", self, "select_item_matching_file")
	
	signals = get_signal_connection_list("file_selected")
	
	# workaround because of some weird behavior
	show()
	yield(get_tree(),"idle_frame")
	var pos = get_parent().rect_global_position + get_parent().rect_size
	set_global_position(pos)
	hide()

func populate():
	var dir = Directory.new()
	dir.open(DIR)
	dir.list_dir_begin(true, false)
	var current := "."
	while current != "":
		current = dir.get_next()
		if dir.current_is_dir():
			continue
		if current.ends_with(".import"):
			var resource_name = current.get_basename()
			add_item(resource_name)


func index_pressed(index: int):
	var base_file = DIR.plus_file(get_item_text(index))
	print("selected file \"{file}\".".format({
			"file": base_file
		}))
	var current_signals = get_signal_connection_list("file_selected")
	assert(str(signals) == str(current_signals))
	emit_signal("file_selected", base_file)

var selected_item_text = ""
func about_to_show():
	pass

func select_item_matching_file(file:String):
	selected_item_text = file.get_file()

	select_item_matching_text()

func select_item_matching_text():
	get_parent().hint_tooltip = selected_item_text

	for i in get_item_count():
		var item_text = get_item_text(i)
		if item_text == selected_item_text:
			set_item_icon(i, preload("res://icon16x16.png"))
		else:
			set_item_icon(i, null)
