extends Control


func can_drop_data(_position, data):
	if (
		!(data is Object) or 
		owner.get_class() != data.get_class() or 
		owner.get_script() != data.get_script()
	):
		return false

	var parent = owner.get_parent()
	var space : Control = parent.drop_space
	var index = owner.get_index()
	parent.move_child(space, index)
	space.show()

	return true

func drop_data(_position, data):
	print(data, " being dropped on ", owner)
	var parent = owner.get_parent()
	var space : Control = parent.drop_space
	parent.move_child(data, space.get_index())

func _process(_delta):
	visible = get_viewport().gui_is_dragging()
