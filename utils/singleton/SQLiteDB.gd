extends Node
var db = SQLiteWrapper.new()
func _init():
	db.set_path("database.db")
	db.foreign_keys = true
	db.open_db()
	
