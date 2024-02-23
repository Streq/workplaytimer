extends Button

onready var sound = $"%sound"

onready var config : Config = $"%config"
func _ready() -> void:
	config.notify_on_init(self, "initialize")

func initialize():
	config.file.connect("sound_on_updated", self, "set_sound_on_internal")
	connect("toggled", self, "set_sound_on")

func set_sound_on_internal(val):
	set_pressed_no_signal(val)

func set_sound_on(val):
	config.file.set_property("sound_on", val)
	sound.play()
