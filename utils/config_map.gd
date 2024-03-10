extends Reference
class_name ConfigMap
signal initialized()
const FileUtils = preload("FileUtils.gd")

# accessed like: config["path1"]["path2"]
var config := {} 

# accessed like: config_flat[PoolStringArray(["path1", "path2"]))
# contains inner nodes also
var config_flat := {}

# accessed like: config_flat[PoolStringArray(["path1", "path2"]))
# contains only leaves
var config_leaves_flat := {}

# accessed like: config_flat[PoolStringArray(["path1", "path2"])]
var config_flat_string := {}

# accessed like: hints[PoolStringArray(["path1", "path2"])]
var hints := {}

var refs := []

var file_path := ""


func get_reference_arr(path: PoolStringArray) -> MapUtils.Ref:
	return config_flat[path]

func get_reference(path: String) -> MapUtils.Ref:
	return config_flat_string[path]

func on_prop_change_notify_obj(prop: String, object: Object, function: String, binds: Array = [], flags: int = 0):
	var ref := get_reference(prop)
	ref.connect("changed", object, function, binds, flags)
func on_prop_change_notify_obj_arr(prop: PoolStringArray, object: Object, function: String, binds: Array = [], flags: int = 0):
	var ref := get_reference_arr(prop)
	ref.connect("changed", object, function, binds, flags)

func on_obj_signal_modify_prop(prop: String, object: Object, object_signal: String):
	var ref := get_reference(prop)
	object.connect(object_signal, ref, "set_value")
func on_obj_signal_modify_prop_arr(prop: PoolStringArray, object: Object, object_signal: String):
	var ref := get_reference_arr(prop)
	object.connect(object_signal, ref, "set_value")

signal creating
var init_started = false
func create_config_from(default_values: Dictionary):
	if init_started:
		return
	init_started = true
	emit_signal("creating")
	
	config = {}
	config_flat = {}
	config_leaves_flat = {}
	config_flat_string = {}
	hints = {}
	refs = []
	
	var nodes = [{value = default_values, keys = PoolStringArray()}]
	var i = 0
	while i < nodes.size():
		var node = nodes[i]
		i += 1
		
		# passed by value, keys is a copy
		var keys : PoolStringArray = node.keys
		var keys_string : String = keys.join("/")
		
		
		var value = node.value
		
		var ref := MapUtils.put_if_absent_recursive(config, keys, value)
		
		config_flat[keys] = ref
		config_flat_string[keys_string] = ref
		refs.append(ref)
		ref.connect("updated_internal", self, "save")

		var type := typeof(value)
		if type != TYPE_DICTIONARY:
			config_leaves_flat[keys] = ref
			continue
			
		var map : Dictionary = value
		for key in map:
			# passed by value, keys_ is a copy
			var keys_ : PoolStringArray = keys
			keys_.append(key)
			
			var entry = map[key]
			
			if entry is Dictionary:
				hints[keys_] = entry.get("hint", "")
				nodes.append({value = entry.value, keys = keys_})
			else:
				nodes.append({value = entry, keys = keys_})

func initialize(default_values: Dictionary, path: String) -> void:
	create_config_from(default_values)
	
	file_path = path
	
	var error = _load_config()
	if error:
		push_warning("configuration file not found for {file}, creating one with default values".format({ 
			"file" : file_path.get_file() 
		}))
		save()

	emit_signal("initialized")
	emit_updates()

func _load_config():
	var new_config = FileUtils.load_json_file_as_dict(file_path)
	if new_config == null:
		return -1
	if typeof(new_config) == TYPE_DICTIONARY:
		for k in config_leaves_flat:
			var keys : PoolStringArray = k
			if !MapUtils.has_recursive(new_config, keys):
				continue
			var ref := get_reference_arr(keys)
			ref._set_value(MapUtils.get_recursive(new_config, keys))
	return 0
	
func emit_updates():
	for r in config_flat.values():
		var ref : MapUtils.Ref = r
		ref.re_emit()

func set_property(path: String, val):
	get_reference(path).value = val

func keys(path:String) -> PoolStringArray:
	return path.split("/")

func get_property(path: String):
	return get_reference(path).value

func get_hint(path: PoolStringArray) -> String:
	return hints.get(path, "")

func save():
	FileUtils.save_json_file(file_path, config)

func get_properties() -> PoolStringArray:
	return PoolStringArray(config_flat_string.keys())
