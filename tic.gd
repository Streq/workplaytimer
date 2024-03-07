extends Button
signal sound_on(val)

onready var sound = $"%sound"
func _ready() -> void:
	ConfigNode.find_config_and_connect(self, "initialize")
var signals
func initialize(config: ConfigMap):
	config.connect("creating",self,"creating")
	
	config.on_prop_change_notify_obj("sound_on", self, "set_sound_on_internal")
	config.on_obj_signal_modify_prop("sound_on", self, "sound_on")
#	signals = get_signal_connection_list("sound_on")
	
	connect("toggled", self, "set_sound_on")
	
func set_sound_on_internal(val):
	set_pressed_no_signal(val)

func creating():
	# TODO ACÁ ESTÁ EL PROBLEMA
	print("ah sos cualquiera")
	breakpoint

func set_sound_on(val):
#	var new_signals = get_signal_connection_list("sound_on")
#	assert(str(new_signals) == str(signals))
	emit_signal("sound_on", val)
	sound.play()
