extends Node

class TimeLogger:
	enum Action {
		START,
		STOP
	}
	class Entry:
		var act : String
		var time : int
	var timestamps
	

func _ready():
	pass
