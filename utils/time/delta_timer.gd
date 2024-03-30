extends Reference

var _last_update_millis := 0
const Chronos = preload("../Chronos.gd")

func get_and_reset() -> int:
	var now_millis = Chronos.now_mil()
	var delta = now_millis - _last_update_millis
	_last_update_millis = now_millis
	return delta

func get_() -> int:
	var now_millis = Chronos.now_mil()
	var delta = now_millis - _last_update_millis
	return delta

func _init():
	get_and_reset()
