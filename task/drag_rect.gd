extends Control

func _ready():
	DragDrop.connect("drag", self, "_on_drag")
	DragDrop.connect("drop", self, "_on_drop")
	
func get_drag_data(position):
	var dupe = owner.duplicate(0)
	var preview = Control.new()
	preview.mouse_filter = MOUSE_FILTER_IGNORE
	preview.add_child(dupe)
	preview.modulate.a = 0.5
	dupe.set_position(-position)
	set_drag_preview(preview)
	return owner

func _on_drag(data):
	if data != owner:
		return
	owner.hide()
	

func _on_drop(data):
	if data != owner:
		return 
	owner.show()
