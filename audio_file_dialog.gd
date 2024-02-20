extends PopupMenu
const DIR = "res://assets/sfx/"
func _ready():
	yield(owner,"ready")
	
	populate()
	
	connect("index_pressed", self, "index_pressed")
	connect("about_to_show", self, "about_to_show")
	
	owner.config.connect("audio_file_updated", self, "select_item_matching_file")
	
	# workaround because of some weird behavior
	show()
	yield(get_tree(),"idle_frame")
	var pos = get_parent().rect_global_position + get_parent().rect_size
	set_global_position(pos)
	hide()
	owner.config.emit_updates()

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
	
	owner.config.set_property("audio_file", base_file)

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
