extends AcceptDialog

const SHINE = preload("res://task/tutorial_shine.tscn")

func _ready():
	connect("about_to_show",self,"_on_about_to_show")
	connect("popup_hide",self,"_on_popup_hide")

var map = {}
var shines = []

func _on_about_to_show():
	var shinables = Groups.get_all("shine_on_advice_start_task")
	for s in shinables:
		var control : Control = s
		if control.has_method("is_moot") and control.is_moot():
			continue
		var shine = SHINE.instance()
		shines.append(shine)
		map[control] = shine
		control.add_child(shine)
#		control.theme_type_variation = "tutorial_shine"
func _on_popup_hide():
	for shine in shines:
		if is_instance_valid(shine):
			shine.queue_free()
#		control.theme_type_variation = ""
