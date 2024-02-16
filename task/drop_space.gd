extends Control


func _process(_delta):
	if !get_viewport().gui_is_dragging():
		visible = false
