extends Button


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed", self, "copy_to_clipboard")

func copy_to_clipboard():
	OS.clipboard = $"%label".text
