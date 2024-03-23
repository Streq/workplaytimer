extends Object
class_name TypeUtils
func _init():
	var msg = "%s is an utility class, you are not supposed to instantiate it." % get_script().resource_path
	assert(false, msg)
	printerr(msg)

static func get_type(code: int) -> String:
	match code:
		TYPE_NIL: return "null"
		TYPE_BOOL: return "bool"
		TYPE_INT: return "int"
		TYPE_REAL: return "float"
		TYPE_STRING: return "String"
		TYPE_VECTOR2: return "Vector2"
		TYPE_RECT2: return "Rect2"
		TYPE_VECTOR3: return "Vector3"
		TYPE_TRANSFORM2D: return "Transform2D"
		TYPE_PLANE: return "Plane"
		TYPE_QUAT: return "Quat"
		TYPE_AABB: return "AABB"
		TYPE_BASIS: return "Basis"
		TYPE_TRANSFORM: return "Transform"
		TYPE_COLOR: return "Color"
		TYPE_NODE_PATH: return "NodePath"
		TYPE_RID: return "RID"
		TYPE_OBJECT: return "Object"
		TYPE_DICTIONARY: return "Dictionary"
		TYPE_ARRAY: return "Array"
		TYPE_RAW_ARRAY: return "PoolByteArray"
		TYPE_INT_ARRAY: return "PoolIntArray"
		TYPE_REAL_ARRAY: return "PoolRealArray"
		TYPE_STRING_ARRAY: return "PoolStringArray"
		TYPE_VECTOR2_ARRAY: return "PoolVector2Array"
		TYPE_VECTOR3_ARRAY: return "PoolVector3Array"
		TYPE_COLOR_ARRAY: return "PoolColorArray"
		_: return "Unknown"

static func cast(val, type: int):
	if typeof(val) == type:
		return val
	match type:
		TYPE_NIL: return val
		TYPE_BOOL: return bool(val)
		TYPE_INT: return int(val)
		TYPE_REAL: return float(val)
		TYPE_STRING: return String(val)
		TYPE_TRANSFORM2D: return Transform2D(val)
		TYPE_TRANSFORM: return Transform(val)
		TYPE_COLOR: return Color(val)
		TYPE_NODE_PATH: return NodePath(val)
		TYPE_RID: return RID(val)
		TYPE_ARRAY: return Array(val)
		TYPE_RAW_ARRAY: return PoolByteArray(val)
		TYPE_INT_ARRAY: return PoolIntArray(val)
		TYPE_REAL_ARRAY: return PoolRealArray(val)
		TYPE_STRING_ARRAY: return PoolStringArray(val)
		TYPE_VECTOR2_ARRAY: return PoolVector2Array(val)
		TYPE_VECTOR3_ARRAY: return PoolVector3Array(val)
		TYPE_COLOR_ARRAY: return PoolVector3Array(val)
		_: assert(false, "invalid type cast")
	return null

# this sucks but whatever
static func can_cast(type: int, to_type: int) -> bool:
	if type == to_type:
		return true
	match to_type:
		TYPE_NIL: return true
		
		TYPE_STRING: return true

		TYPE_BOOL: match type: 
			TYPE_INT: return true
			TYPE_REAL: return true
			TYPE_STRING: return true
			_: return false
			
		TYPE_INT: match type: 
			TYPE_BOOL: return true
			TYPE_REAL: return true
			TYPE_STRING: return true
			_: return false
			
		TYPE_REAL: match type: 
			TYPE_BOOL: return true
			TYPE_INT: return true
			TYPE_STRING: return true
			_: return false
			
		TYPE_COLOR: match type: 
			TYPE_INT: return true
			TYPE_STRING: return true
			_: return false

		TYPE_TRANSFORM2D: match type:
			TYPE_TRANSFORM: return true
			_: return false

		TYPE_TRANSFORM: match type:
			TYPE_TRANSFORM2D: return true
			_: return false

		TYPE_NODE_PATH: match type:
			TYPE_STRING: return true
			_: return false

		TYPE_RID: match type:
			TYPE_OBJECT: return true
			_: return false
		
		TYPE_INT_ARRAY: match type: 
			TYPE_ARRAY: return true
			_: return false

		TYPE_RAW_ARRAY: match type: 
			TYPE_ARRAY: return true
			_: return false
			
		TYPE_REAL_ARRAY: match type: 
			TYPE_ARRAY: return true
			_: return false
			
		TYPE_STRING_ARRAY: match type: 
			TYPE_ARRAY: return true
			_: return false
			
		TYPE_VECTOR2_ARRAY: match type: 
			TYPE_ARRAY: return true
			_: return false
			
		TYPE_VECTOR3_ARRAY: match type: 
			TYPE_ARRAY: return true
			_: return false
			
		TYPE_COLOR_ARRAY: match type: 
			TYPE_ARRAY: return true
			_: return false
			
		TYPE_ARRAY: match type: 
			TYPE_INT_ARRAY: return true
			TYPE_RAW_ARRAY: return true
			TYPE_REAL_ARRAY: return true
			TYPE_STRING_ARRAY: return true
			TYPE_VECTOR2_ARRAY: return true
			TYPE_VECTOR3_ARRAY: return true
			TYPE_COLOR_ARRAY: return true
			_: return false

		_: return false

static func safe_cast(val, type: int):
	var old_type = typeof(val)
	assert(can_cast(old_type, type), "Type mismatch: cast %s((%s)%s) cannot be performed" % [get_type(type), get_type(old_type), val])
	return cast(val, type)

	
