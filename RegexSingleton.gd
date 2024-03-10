extends Node
var NON_WHITESPACE := RegEx.new()

func _ready():
	NON_WHITESPACE.compile("\\S+")
