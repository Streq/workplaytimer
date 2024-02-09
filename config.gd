extends Node
class_name Config

signal audio_file_updated(audio)
signal sound_on_updated(val)
signal interval_updated(val)
signal volume_updated(val)

onready var CONFIG_PATH: String = Global.PATH.plus_file("config").plus_file(owner.name+".json")
var config = {
	audio_file = "res://assets/sfx/click.wav",
	sound_on = false,
	interval = 1.0,
	volume = 0.0
}

func initialize() -> void:
	yield(get_tree(),"idle_frame")
	
	if _load_config() == -1:
		print("configuration file not found for {file}, creating one with default values".format({ 
			"file" : CONFIG_PATH.get_file() 
		}))
		save()

	_refresh_config()

func _load_config():
	var new_config = FileUtils.load_json_file(CONFIG_PATH)
	if new_config == null:
		return -1
	if typeof(new_config) == TYPE_DICTIONARY:
		for key in config.keys():
			if new_config.has(key):
				config[key] = new_config[key]
	return 0
	

	

func _refresh_config():
	emit_signal("sound_on_updated",config.sound_on)
	emit_signal("audio_file_updated",config.audio_file)
	emit_signal("interval_updated",config.interval)
	emit_signal("volume_updated",config.volume)


func set_property_no_signal(prop_name, prop_value):
	config[prop_name] = prop_value
func set_property(prop_name, prop_value):
	set_property_no_signal(prop_name, prop_value)
	emit_signal(prop_name+"_updated", prop_value)
	save()

func save():
	FileUtils.save_json_file(CONFIG_PATH, config)
