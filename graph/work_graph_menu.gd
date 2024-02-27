extends VBoxContainer


onready var hours_on_window = $"%hours_on_window"

onready var work_graph = $"%work_graph"


func _ready():
	hours_on_window.connect("text_entered", self ,"_on_hours_on_window_entered")
	refresh()
func _on_hours_on_window_entered(text):
#	work_graph.refresh()
	pass

func refresh():
	work_graph.refresh()
