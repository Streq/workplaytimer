extends Control

const Task = preload("task.gd")
var data : Task = null


func can_drop_data(_position, data):
	return data is Task

func drop_data(_position, data):
	_drop_data(data)

func _drop_data(data):
	get_parent().move_child(data, get_index())
	self.data = null

func _ready():
	DragDrop.connect("drag", self, "_on_drag_begun")
	DragDrop.connect("drop", self, "_on_drag_ended")
	visible = DragDrop.is_dragging()

func _on_drag_begun(data):
	if not data is Task:
		return
	show()
	self.data = data
	rect_min_size = data.rect_size

func _on_drag_ended(data):
	hide()
	if is_instance_valid(data) and self.data == data:
		_drop_data(data)
