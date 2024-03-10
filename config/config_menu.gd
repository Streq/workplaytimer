extends MarginContainer

var config_list : VBoxContainer
func _ready():
	ConfigNode.find_config_and_connect(self, "initialize")

func init_config_list():
	for child in get_children():
		if child is VBoxContainer:
			config_list = child
			return
	config_list = VBoxContainer.new()
	add_child(config_list)
	

func initialize(config: ConfigMap):
	init_config_list()
	config_list.add_child(main_section(config))

const ConfigSection = preload("res://config/config_section.tscn")


func main_section(config: ConfigMap):
	var control := VBoxContainer.new()
	
	var node : Dictionary = config.config
		
	for key in node:
		var sub_key_stack = PoolStringArray([key])
		var child_control := choose_control(config, sub_key_stack)
		control.add_child(child_control)
	
	return control
func section(config: ConfigMap, key_stack := PoolStringArray()):
	var control := ConfigSection.instance()
	
	var node_ref := config.get_reference_arr(key_stack)
	var node : Dictionary = node_ref.value
	
	if !key_stack.empty():
		var base_key : String = node_ref.key
		var title = base_key.capitalize()
		control.set_label(title)
	
	for key in node:
		var sub_key_stack = key_stack+PoolStringArray([key])
		var child_control := choose_control(config, sub_key_stack)
		control.add_child(child_control)
	
	return control

func choose_control(config : ConfigMap, key_stack: PoolStringArray) -> Control:
	var sub_node_ref := config.get_reference_arr(key_stack)
	var type = sub_node_ref.type()
	
	var ret : Control
	match type:
		TYPE_DICTIONARY:
			ret = section(config, key_stack)
		TYPE_BOOL:
			ret = checkbox(config, key_stack)
		TYPE_STRING:
			ret = line_edit(config, key_stack)
		TYPE_INT:
			ret = int_edit(config, key_stack)
		TYPE_REAL:
			ret = real_edit(config, key_stack)
		_:
			ret = line_edit(config, key_stack)
	
	var hint = StringUtils.wrap_string(config.get_hint(key_stack), 40)
	ret.hint_tooltip = hint
	return ret
func checkbox(config: ConfigMap, prop: PoolStringArray) -> CheckBox:
	var ret = CheckBox.new()
	
	config.on_prop_change_notify_obj_arr(prop, ret, "set_pressed_no_signal")
	config.on_obj_signal_modify_prop_arr(prop, ret, "toggled")
	
	ret.text = get_title(prop)
	return ret

const ConfigString = preload("res://config/config_string.tscn")
func line_edit(config: ConfigMap, prop: PoolStringArray) -> Control:
	var ret = ConfigString.instance()
	config.on_prop_change_notify_obj_arr(prop, ret, "set_value_no_signal")
	config.on_obj_signal_modify_prop_arr(prop, ret, "value_changed")
	
	ret.label = get_title(prop)
	return ret
	
const ConfigNumber = preload("res://config/config_number.tscn")
func real_edit(config: ConfigMap, prop: PoolStringArray) -> Control:
	var ret = ConfigNumber.instance()
	config.on_prop_change_notify_obj_arr(prop, ret, "set_value_no_signal")
	config.on_obj_signal_modify_prop_arr(prop, ret, "value_changed")
	
	ret.label = get_title(prop)
	return ret
func int_edit(config: ConfigMap, prop: PoolStringArray) -> Control:
	var ret = ConfigNumber.instance()
	config.on_prop_change_notify_obj_arr(prop, ret, "set_value_no_signal")
	config.on_obj_signal_modify_prop_arr(prop, ret, "value_changed")

	ret.label = get_title(prop)
	return ret

func has_property_handler(prop) -> bool:
	return config_list.has_node(prop)

static func get_title(path: PoolStringArray) -> String:
	var size = path.size()
	if !size:
		return ""
	var name := path[size-1]
	return name.capitalize()
