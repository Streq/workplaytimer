extends PanelContainer

signal submit(address,port)

onready var address_input = $"%address"
onready var port_input = $"%port"
onready var submit = $"%submit"

func _ready():
	submit.connect("pressed", self, "_submit")

func _submit():
	var port = port_input.value.to_int()
	var address = address_input.value
	emit_signal("submit", address, port)
