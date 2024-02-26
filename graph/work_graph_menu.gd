extends VBoxContainer


onready var seconds_per_pixel = $"%seconds_per_pixel"

onready var work_graph = $work_graph

# Called when the node enters the scene tree for the first time.
func _ready():
	seconds_per_pixel.connect("text_entered", self ,"_on_seconds_per_pixel_entered")
	
func _on_seconds_per_pixel_entered(text):
	work_graph.seconds_per_pixel = float(text)
	work_graph.refresh()
