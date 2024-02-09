extends FileDialog

func _ready():
	yield(owner,"ready")
	connect("file_selected",self,"file_selected")
	current_dir = "res://assets/sfx/"
func file_selected(file):
	owner.config.set_property("audio_file", file)
