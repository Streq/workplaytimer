extends Object
class_name MapUtils
func _init():
	var msg = "%s is an utility class, you are not supposed to instantiate it." % get_script().resource_path
	assert(false, msg)
	printerr(msg)

"""
References the value held by a given key on a given map.
Useful for accessing pass-by-value values stored in a map, 
without needing an explicit reference to that map
"""
class Ref extends Reference:

	signal changed(val)
	signal updated()
	signal updated_internal()

	var map: Dictionary
	var key
	var value setget set_value, get_value
	func _init(map_: Dictionary, key_):
		map = map_
		key = key_

	func get_value():
		return map[key]
	func _set_value(val):
		map[key] = val

	func type() -> int:
		return typeof(map[key])

	func set_value(val):
		var type := type()
		var type_to_set := typeof(val)
		assert(type_to_set == type, "type mismatch")
		_set_value(val)
		emit_signal("updated_internal")
		emit_signal("changed", val)
		emit_signal("updated")
	func re_emit():
		emit_signal("changed", get_value())
		emit_signal("updated")
	func _to_string():
		return "Ref(\n\tmap: %s, \n\tkey: %s, \n\tvalue: %s\n)" % [str(map), str(key), str(map[key])]



static func put_if_absent(map: Dictionary, key, value):
	if map.has(key):
		return map[key]
	map[key] = value
	return value

static func compute_if_absent(map: Dictionary, key, supplier: FuncRef):
	if map.has(key):
		return map[key]
	var value = supplier.call_func()
	map[key] = value
	return value

static func get_recursive(map: Dictionary, keys: Array):
	if keys.empty():
		return map
	var node = map
	for key in keys:
		 node = node[key]
	return node
static func get_recursive_or_else(map: Dictionary, keys: Array, default = null):
	if keys.empty():
		return map
	var node = map
	for key in keys:
		if !node.has(key):
			return default
		node = node[key]
	return node
static func has_recursive(map: Dictionary, keys: Array) -> bool:
	if keys.empty():
		return true
	var node = map
	for key in keys:
		if typeof(node) != TYPE_DICTIONARY or !node.has(key):
			return false
		node = node[key]
	return true

static func put_if_absent_recursive(map: Dictionary, keys: Array, value) -> Ref:
	if keys.empty():
		return get_root_reference(map)
	var node = map
	var inner_nodes = keys.size()-1
	
	for i in inner_nodes:
		var key = keys[i]
		node = put_if_absent(node, key, {})
	
	var key = keys[inner_nodes]
	put_if_absent(node, key, value)
	return Ref.new(node, key)

static func set_type_sensitive(map: Dictionary, key, val):
	assert(key in map, "trying to set inexistent property")
	assert(typeof(val) == map[key], "property set: type mismatch")
	map[key] = val

static func set_recursive_type_sensitive(map: Dictionary, keys: Array, val) -> Ref:
	if keys.empty():
		return get_root_reference(map)
	var node = map
	var inner_nodes = keys.size()-1
	var key
	for i in inner_nodes:
		key = keys[i]
		assert(key in node, "trying to set inexistent property")
		node = node[key]
		assert(typeof(node) == TYPE_DICTIONARY, "trying to set inexistent property")
	
	key = keys[inner_nodes]
	assert(key in node, "trying to set inexistent property")
	assert(typeof(val) == map[key], "property set: type mismatch")
	node[key] = val
	return Ref.new(node, key)
	

static func get_root_reference(map: Dictionary) -> Ref:
	return Ref.new({null:map}, null)

static func set_recursive_or_create(map: Dictionary, keys: Array, value) -> Ref:
	if keys.empty():
		return get_root_reference(map)
	var node := map
	var inner_nodes = keys.size()-1
	
	for i in inner_nodes:
		var key = keys[i]
		node = put_if_absent(node, key, {})
	
	var final_key = keys[inner_nodes]
	node[final_key] = value
	return Ref.new(node, final_key)

static func set_recursive(map: Dictionary, keys: Array, value) -> Ref:
	if keys.empty():
		return get_root_reference(map)
	var node := map
	var inner_nodes = keys.size()-1
	
	for i in inner_nodes:
		var key = keys[i]
		node = node[key]
	
	var final_key = keys[inner_nodes]
	node[final_key] = value
	return Ref.new(node, final_key)

static func get_value_reference_recursive(map: Dictionary, keys: Array) -> Ref:
	if keys.empty():
		return get_root_reference(map)
	var node := map
	var inner_nodes = keys.size()-1
	
	for i in inner_nodes:
		var key = keys[i]
		node = node[key]
	
	var key = keys[inner_nodes]
	return Ref.new(node, key)


static func get_value_reference(map: Dictionary, key) -> Ref:
	return Ref.new(map, key)


static func get_or_create_value_reference_recursive(map: Dictionary, keys: Array) -> Ref:
	if keys.empty():
		return get_root_reference(map)
	var node := map
	var inner_nodes = keys.size()-1
	
	for i in inner_nodes:
		var key = keys[i]
		node = node.get(key, {})
	
	var key = keys[inner_nodes]
	return Ref.new(node, key)
