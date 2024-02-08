extends Button

onready var sound = $"%sound"

func _ready() -> void:
	yield(owner,"ready")
	owner.config.connect("sound_on_updated",self,"set_sound_on_internal")
	connect("toggled", self,"set_sound_on")

func set_sound_on_internal(val):
	set_pressed_no_signal(val)

func set_sound_on(val):
	owner.config.set_property("sound_on", val)

