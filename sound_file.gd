extends Button

onready var sound = $"%sound"
onready var dialog = $"%audio_file_dialog"




func _ready():
	connect("pressed", self, "pressed")
	dialog.connect("popup_hide", sound, "play")

func pressed():
	dialog.popup()
