extends Node
signal drag_ended()
signal drop(data)
signal drag_begun()
signal drag(data)

var data = null
func _notification(what):
	match what:
		NOTIFICATION_DRAG_BEGIN:
			data = get_viewport().gui_get_drag_data()
			emit_signal("drag", data)
			emit_signal("drag_begun")
		NOTIFICATION_DRAG_END:
			emit_signal("drop", data)
			data = null
			emit_signal("drag_ended")

func is_dragging():
	return data != null
