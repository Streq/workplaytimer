extends Node2D


func _ready():
	var map = {}
	var ref := MapUtils.put_if_absent_recursive(map, ["hola", "bro"], true)
	var ref2 := MapUtils.put_if_absent_recursive(map, ["hola", "sis"], false)
	print(map)
	ref2.value = true
	print(map)
