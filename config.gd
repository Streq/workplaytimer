extends Node
class_name Config

signal audio_file_updated(audio)
signal sound_on_updated(val)
signal interval_updated(val)

onready var CONFIG_PATH: String = Global.PATH.plus_file("config").plus_file(owner.name+".json")
var config = {
	audio_file = "res://assets/sfx/click.wav",
	sound_on = false,
	interval = 1.0
}

func initialize() -> void:
	yield(get_tree(),"idle_frame")
	
	if _load_config() == -1:
		print("configuration file not found for {file}, creating one with default values".format({ 
			"file" : CONFIG_PATH.get_file() 
			}))
		_create_config_file()

	_refresh_config()

func _load_config():
	var new_config = load_json_file(CONFIG_PATH)
	if new_config == null:
		return -1
	if typeof(new_config) == TYPE_DICTIONARY:
		for key in config.keys():
			if new_config.has(key):
				config[key] = new_config[key]
	return 0
	
func _create_config_file():
	_create_dir_for_file_if_not_exists(CONFIG_PATH)
	var file = File.new()
	var error = file.open(CONFIG_PATH, File.WRITE)
	if error:
		push_error("couldn't create config file at {file}, error code {error}".format({file=CONFIG_PATH,error=str(error)}))
		return
	file.store_string(JSON.print(config,"\t"))
	file.close()

static func _create_dir_for_file_if_not_exists(file_path):
	var file = file_path.get_file()
	var dir_path = file_path.trim_suffix(file)
	var directory = Directory.new()
	if !directory.dir_exists(dir_path):
		var msg = "directory {dir} absent for {file}, creating one.".format({dir=dir_path, file=file})
		push_warning(msg)
		directory.make_dir_recursive(dir_path)
	

func _refresh_config():
	emit_signal("sound_on_updated",config.sound_on)
	emit_signal("audio_file_updated",config.audio_file)
	emit_signal("interval_updated",config.interval)

static func load_json_file(json_path):
	var file = File.new()
	var error = file.open(json_path, file.READ)
	if(error):
		push_warning("couldn't open json file at " + json_path + ", error code " + str(error))
		return null
	var text = file.get_as_text()
	var json : JSONParseResult = JSON.parse(text)
	file.close()
	if json.error:
		push_warning("couldn't read json file at " + json_path + ", error code " + str(json.error))
		return null
	return json.result

func set_property_no_signal(prop_name, prop_value):
	config[prop_name] = prop_value
func set_property(prop_name, prop_value):
	set_property_no_signal(prop_name, prop_value)
	emit_signal(prop_name+"_updated", prop_value)
	_create_config_file()
