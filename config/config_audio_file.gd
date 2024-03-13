extends Button

func set_title(val:String):
	pass
func set_value(val:String):
	pass

onready var dialog = $"%audio_file_dialog"

func _ready():
	connect("pressed", self, "pressed")

func pressed():
	dialog.popup()
