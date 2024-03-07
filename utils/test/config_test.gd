extends Node2D


func _ready():
#	print(MathUtils.invert_range(3))
#
#	var regex = RegEx.new()
#	regex.compile("[a-zA-Z_]+")
##	var sub = regex.sub("02", "", true)
#	var sub = "ranges(3).size()"
#	print(sub)
#
#	var e = Expression.new()
#	var error = e.parse(sub)
#	if error:
#		print("couldn't parse")
#		return
#	var res = e.execute()
#	print(res)
	print(StringUtils.wrap_string("hola amigo\n\nsoy santi tu mejor amigo capo hermano.", 18))
	print(MapUtils.get_recursive({hola={chau=2}}, PoolStringArray(["hola","chau"])))
	add_user_signal("hola/jaja")
	connect("hola/jaja",self,"_lmao")
	emit_signal("hola/jaja")
func _lmao():
	print("funcionó")
