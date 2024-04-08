extends Node2D




func unixepoch(value : String, modifiers: PoolStringArray):
	var query = "SELECT unixepoch({value}, {modifiers})".format({
		"value": "'"+value+"'", 
		"modifiers": "'" + modifiers.join("', '") + "'"
	})
	Persistence.db.query(query)
	return Persistence.db.get_query_result()[0].values()[0]


# Called when the node enters the scene tree for the first time.
func _ready():
	var ret = unixepoch("now", ['start of month', '+7 days', 'weekday 5', "+17 hours"])
	print(ret)
	print(Time.get_date_dict_from_unix_time(ret))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
