extends Button

onready var sound = $sound

func _ready() -> void:
	connect("pressed", self, "tic")
	tic()
func tic():
	sound.set_process(self.pressed)
