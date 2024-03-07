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
	
	for prop in config.get_properties():
		if has_property_handler(prop):
			continue
		var type = config.get_reference(prop).type()
		var control : Control
		match type:
			TYPE_BOOL:
				control = checkbox(config, prop)
			TYPE_STRING:
				control = line_edit(config, prop)
			TYPE_INT:
				control = int_edit(config, prop)
			TYPE_REAL:
				control = real_edit(config, prop)
			_:
				control = line_edit(config, prop)
		
		control.hint_tooltip = StringUtils.wrap_string(config.get_hint(prop), 40)
		
		config_list.add_child(control)

func checkbox(config: ConfigMap, prop: String) -> CheckBox:
	var ret = CheckBox.new()
	
	config.on_prop_change_notify_obj(prop, ret, "set_pressed_no_signal")
	config.on_obj_signal_modify_prop(prop, ret, "toggled")
	
	ret.text = prop.capitalize()
	return ret

const ConfigString = preload("res://config/config_string.tscn")
func line_edit(config: ConfigMap, prop: String) -> Control:
	var ret = ConfigString.instance()
	ret.label = prop.capitalize()
	config.on_prop_change_notify_obj(prop, ret, "set_value_no_signal")
	config.on_obj_signal_modify_prop(prop, ret, "value_changed")
	return ret
	
const ConfigNumber = preload("res://config/config_number.tscn")
func real_edit(config: ConfigMap, prop: String) -> Control:
	var ret = ConfigNumber.instance()
	ret.label = prop.capitalize()
	config.on_prop_change_notify_obj(prop, ret, "set_value_no_signal")
	config.on_obj_signal_modify_prop(prop, ret, "value_changed")
	return ret
func int_edit(config: ConfigMap, prop: String) -> Control:
	var ret = ConfigNumber.instance()
	ret.label = prop.capitalize()
	config.on_prop_change_notify_obj(prop, ret, "set_value_no_signal")
	config.on_obj_signal_modify_prop(prop, ret, "value_changed")
	return ret

func has_property_handler(prop) -> bool:
	return config_list.has_node(prop)
