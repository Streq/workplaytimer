extends Node
var NON_WHITESPACE := RegEx.new()
var SQL_SELECT_SCALAR_STATEMENT := RegEx.new()
func _ready():
	NON_WHITESPACE.compile("\\S+")

	# Finds {scalar} as: 
	# "SELECT {scalar};"
	# "{scalar};"
	# "{scalar}"
	# "SELECT {scalar}"
	# "select {scalar}"
	# "{scalar};;;;;"
	SQL_SELECT_SCALAR_STATEMENT.compile("(?i)^(SELECT +)?(?<scalar>.*[^;]+);*$")
