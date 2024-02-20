extends Button
onready var popup = $"%popup"

func _ready():
	connect("pressed", popup, "popup_centered")
