extends Control

onready var clear = $"%clear"
onready var console = $"%console"

func _ready():
	clear.connect("pressed", console, "clear")
