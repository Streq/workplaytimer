tool
extends Control


func _ready():
	var rect = get_child(0).get_global_rect().size
	rect_min_size = Vector2(rect.y, rect.x)
