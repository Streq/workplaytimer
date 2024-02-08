extends Button


func _ready() -> void:
	connect("pressed", self, "copy_to_clipboard")

func copy_to_clipboard():
	OS.clipboard = $"%label".text
