extends Control

const Task = preload("task.gd")

func _ready():
	DragDrop.connect("drag_begun", self, "show")
	DragDrop.connect("drag_ended", self, "hide")
	visible = DragDrop.is_dragging()
	connect("mouse_entered", self, "_on_mouse_entered")
func move_drop_space():
	var parent = owner.get_parent()
	var space : Control = parent.drop_space
	var index = owner.get_index()
	parent.move_child(space, index)

func _gui_input(event):
	if event is InputEventMouseMotion:
		_on_mouse_entered()

func _on_mouse_entered():
	if DragDrop.is_dragging():
		move_drop_space()
	
	
	
