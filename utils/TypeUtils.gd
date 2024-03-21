extends Object
class_name TypeUtils
func _init():
	var msg = "%s is an utility class, you are not supposed to instantiate it." % get_script().resource_path
	assert(false, msg)
	printerr(msg)


const _map = {
 TYPE_NIL : "null",
 TYPE_BOOL : "bool",
 TYPE_INT : "int",
 TYPE_REAL : "float",
 TYPE_STRING : "String",
 TYPE_VECTOR2 : "Vector2",
 TYPE_RECT2 : "Rect2",
 TYPE_VECTOR3 : "Vector3",
 TYPE_TRANSFORM2D : "Transform2D",
 TYPE_PLANE : "Plane",
 TYPE_QUAT : "Quat",
 TYPE_AABB : "AABB",
 TYPE_BASIS : "Basis",
 TYPE_TRANSFORM : "Transform",
 TYPE_COLOR : "Color",
 TYPE_NODE_PATH : "NodePath",
 TYPE_RID : "RID",
 TYPE_OBJECT : "Object",
 TYPE_DICTIONARY : "Dictionary",
 TYPE_ARRAY : "Array",
 TYPE_RAW_ARRAY : "PoolByteArray",
 TYPE_INT_ARRAY : "PoolIntArray",
 TYPE_REAL_ARRAY : "PoolRealArray",
 TYPE_STRING_ARRAY : "PoolStringArray",
 TYPE_VECTOR2_ARRAY : "PoolVector2Array",
 TYPE_VECTOR3_ARRAY : "PoolVector3Array",
 TYPE_COLOR_ARRAY : "PoolColorArray"
}



static func get_type(code: int) -> String:
	return _map[code] if code in _map else "Unknown"

static func cast(val, type: int):
	if typeof(val) == type:
		return val
	match type:
		TYPE_NIL : return val
		TYPE_BOOL : return bool(val)
		TYPE_INT : return int(val)
		TYPE_REAL : return float(val)
		TYPE_STRING : return String(val)
		TYPE_VECTOR2 : assert(false, "invalid type cast")
		TYPE_RECT2 : assert(false, "invalid type cast")
		TYPE_VECTOR3 : assert(false, "invalid type cast")
		TYPE_TRANSFORM2D : return Transform2D(val)
		TYPE_PLANE : assert(false, "invalid type cast")
		TYPE_QUAT : assert(false, "invalid type cast")
		TYPE_AABB : assert(false, "invalid type cast")
		TYPE_BASIS : assert(false, "invalid type cast")
		TYPE_TRANSFORM : return Transform(val)
		TYPE_COLOR : return Color(val)
		TYPE_NODE_PATH : return NodePath(val)
		TYPE_RID : return RID(val)
		TYPE_OBJECT : assert(false, "invalid type cast")
		TYPE_DICTIONARY : assert(false, "invalid type cast")
		TYPE_ARRAY : return Array(val)
		TYPE_RAW_ARRAY : return PoolByteArray(val)
		TYPE_INT_ARRAY : return PoolIntArray(val)
		TYPE_REAL_ARRAY : return PoolRealArray(val)
		TYPE_STRING_ARRAY : return PoolStringArray(val)
		TYPE_VECTOR2_ARRAY : return PoolVector2Array(val)
		TYPE_VECTOR3_ARRAY : return PoolVector3Array(val)
		TYPE_COLOR_ARRAY : return PoolVector3Array(val)
	return null

static func can_cast(type: int, to_type: int) -> bool:
	if type == to_type:
		return true
	match to_type:
		TYPE_NIL : return true
		
		TYPE_BOOL, \
		TYPE_INT, \
		TYPE_REAL: match type:
			TYPE_BOOL, \
			TYPE_INT, \
			TYPE_REAL, \
			TYPE_STRING: return true
			_: return false
		
		TYPE_STRING : return true
		
		TYPE_VECTOR2 : return false
		
		TYPE_RECT2 : return false
		
		TYPE_VECTOR3 : return false
		
		TYPE_TRANSFORM2D : return TYPE_TRANSFORM == type
		
		TYPE_PLANE : return false
		
		TYPE_QUAT : return false
		
		TYPE_AABB : return false
		
		TYPE_BASIS : return false
		
		TYPE_TRANSFORM : return TYPE_TRANSFORM2D == type
		
		TYPE_COLOR : match type:
			TYPE_INT, \
			TYPE_STRING: return true
			_: return false
		
		TYPE_NODE_PATH : return TYPE_STRING == type
		
		TYPE_RID : return TYPE_OBJECT == type
		
		TYPE_OBJECT : return false
		
		TYPE_DICTIONARY : return false
		
		TYPE_ARRAY : match type: 
			TYPE_INT_ARRAY, \
			TYPE_RAW_ARRAY, \
			TYPE_REAL_ARRAY, \
			TYPE_STRING_ARRAY, \
			TYPE_VECTOR2_ARRAY, \
			TYPE_VECTOR3_ARRAY, \
			TYPE_COLOR_ARRAY: return true
			_: return false
		
		TYPE_INT_ARRAY, \
		TYPE_RAW_ARRAY, \
		TYPE_REAL_ARRAY, \
		TYPE_STRING_ARRAY, \
		TYPE_VECTOR2_ARRAY, \
		TYPE_VECTOR3_ARRAY, \
		TYPE_COLOR_ARRAY : return TYPE_ARRAY == type

	return false

static func safe_cast(val, type: int):
	var old_type = typeof(val)
	assert(can_cast(old_type, type), "Type mismatch: cast %s((%s)%s) cannot be performed" % [get_type(type), get_type(old_type), val])
	return cast(val, type)

	
