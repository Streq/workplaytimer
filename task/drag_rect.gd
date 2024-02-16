extends Control


func get_drag_data(position):
	var dupe = owner.duplicate(0)
	var preview = Control.new()
	preview.add_child(dupe)
	preview.modulate.a = 0.5
	dupe.set_position(-position)

	var parent = owner.get_parent()
	var space : Control = parent.drop_space
	var index = owner.get_index()
	parent.move_child(space, index)
	space.show()
	
	set_drag_preview(preview)
	hide_owner()
	return owner

func _ready():
	set_process(false)

var hidden = false
func hide_owner():
	owner.hide()
	hidden = true
	set_process(true)
func _process(_delta):
	if !get_viewport().gui_is_dragging():
		owner.show()
		hidden = false
		set_process(false)
