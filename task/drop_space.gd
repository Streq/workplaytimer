extends Control
signal dropped(drag_data, index)

const Task = preload("task.gd")
var data : Task = null


func can_drop_data(_position, drag_data):
	return drag_data is Task

func drop_data(_position, drag_data):
	_drop_data(drag_data)

func _drop_data(drag_data):
	emit_signal("dropped", drag_data, get_index())
	data = null

func _ready():
	DragDrop.connect("drag", self, "_on_drag_begun")
	DragDrop.connect("drop", self, "_on_drag_ended")
	visible = DragDrop.is_dragging()

func _on_drag_begun(drag_data):
	if not drag_data is Task:
		return
	show()
	data = drag_data
	rect_min_size = data.rect_size

func _on_drag_ended(drag_data):
	hide()
	if is_instance_valid(drag_data) and data == drag_data:
		_drop_data(data)
