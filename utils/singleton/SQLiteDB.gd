extends Node
var db := SQLiteWrapper.new()

func _init():
#	db.verbosity_level = db.VerbosityLevel.VERY_VERBOSE
#	db.set_path("database.db")
#	db.foreign_keys = true
#	db.open_db()
	pass

func scalar(query:String):
#	print("raw query passed:", query)
	query = Regex.SQL_SELECT_SCALAR_STATEMENT.sub(query, "$scalar")
#	print("extracted scalar:", query)
	query = "SELECT (%s);" % query
	var success = db.query(query)
#	prints("success:", success)
	var res = db.get_query_result()
#	print(res)
	return res[0].values()[0]

func unixepoch(params: PoolStringArray):
	return scalar("unixepoch({modifiers})".format({
		"modifiers": "'"+params.join("', '")+"'" if params else ""
	}))
func unixepoch_from(unixepoch: int, modifiers: PoolStringArray):
	return unixepoch(PoolStringArray([str(unixepoch), "unixepoch"])+modifiers)
