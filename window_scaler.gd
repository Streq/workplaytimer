extends Node
func _ready():
	get_tree().root.connect("size_changed", self, "_on_viewport_size_changed")
func _on_viewport_size_changed():

	if not get_tree().current_scene is Control:
		return
	
	var scene : Control = get_tree().current_scene
	var root : Viewport = get_tree().root
	
	var rect_size = scene.rect_size
	var root_size = root.size
	
	if !rect_size.x or !rect_size.y:
		return
	
	if rect_size*scene.rect_scale == root_size:
		return
	
	print("Viewport size changed to ", root_size, " with rect size ", rect_size)
	var scale_vec = root_size/rect_size
	
	var scale = min(scale_vec.x, scale_vec.y)
	
	print(scale)
	scene.rect_scale = Vector2(scale, scale)
