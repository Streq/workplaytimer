extends Control


func can_drop_data(_position, data):
	if (
		!(data is Node) or 
		!data.is_in_group("task")
	):
		return false
	return true

func drop_data(_position, data):
	var space : Control = get_parent()
	var parent = space.get_parent()
	parent.move_child(data, space.get_index())

func _process(_delta):
	visible = get_viewport().gui_is_dragging()
