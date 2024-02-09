extends Button

onready var sound = $"%sound"
onready var dialog = $"%audio_file_dialog"




func _ready():
	connect("pressed",self,"pressed")

func pressed():
	dialog.popup()
