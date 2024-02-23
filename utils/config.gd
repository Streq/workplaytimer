extends Reference
signal initialized()
const FileUtils = preload("FileUtils.gd")

var config = {}
var signals = {}
var types = {}

var path := ""

func notify_on_prop(prop: String, object: Object, function: String, binds: Array = [], flags: int = 0):
	connect(signals[prop], object, function, binds, flags)
	

func register_properties():
	for key in config:
		if not key in types: 
			register_property(key, typeof(config[key]))

func initialize(default_values, file_path) -> void:
	config = default_values
	path = file_path
	
	var error = _load_config()
	if error:
		push_warning("configuration file not found for {file}, creating one with default values".format({ 
			"file" : path.get_file() 
		}))
		save()

	register_properties()
	emit_signal("initialized")
	emit_updates()

func _load_config():
	var new_config = FileUtils.load_json_file_as_dict(path)
	if new_config == null:
		return -1
	if typeof(new_config) == TYPE_DICTIONARY:
		for key in config.keys():
			if new_config.has(key):
				config[key] = new_config[key]
	return 0
	
func emit_updates():
	for key in config:
		emit_signal(signals[key], config[key])

func set_property_no_signal(prop_name, prop_value):
	assert(prop_name in config, "trying to set inexistent property")
	assert(typeof(prop_value) == types[prop_name], "property set: type mismatch")
	config[prop_name] = prop_value

func set_property(prop_name, prop_value):
	set_property_no_signal(prop_name, prop_value)
	emit_signal(signals[prop_name], prop_value)
	save()

func set_or_create(prop_name, val):
	if !prop_name in config:
		register_property(prop_name, typeof(val))
	set_property(prop_name, val)
	
func register_property(key, type: int):
	var signal_name = key+"_updated"
	add_user_signal(signal_name, [{name=key, type=type}])
	signals[key] = signal_name
	types[key] = type

func get_property(prop_name):
	return config[prop_name]

func save():
	FileUtils.save_json_file(path, config)
