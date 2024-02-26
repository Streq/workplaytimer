extends Button
var popup : Popup

func _ready():
	find_popup()

	popup.connect("popup_hide",self,"_on_popup_hide",[], CONNECT_DEFERRED)
	popup.connect("about_to_show",self,"_on_popup_show",[], CONNECT_DEFERRED)

func _on_popup_hide():
	disabled = false
	set_pressed_no_signal(false)
func _on_popup_show():
	disabled = true
	set_pressed_no_signal(true)
	
func find_popup():
	var nodes = []
	nodes.append_array(get_children())
	for child in nodes:
		if child is Popup:
			popup = child
			return
		nodes.append_array(child.get_children())
	assert(false, "Couldn't find popup among children.")


func _pressed():
	popup.popup()
	
func _on_submit(date):
	emit_signal("submit", date)
