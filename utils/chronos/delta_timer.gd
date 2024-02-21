extends Reference

var _last_update_millis := 0

func get_and_reset() -> int:
	var now_millis = Global.now_millis()
	var delta = now_millis - _last_update_millis
	_last_update_millis = now_millis
	return delta

func _init():
	get_and_reset()
