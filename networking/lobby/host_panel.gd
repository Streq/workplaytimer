extends PanelContainer
signal submit(port)

onready var address_input = $"%address"
onready var port_input = $"%port"
onready var submit = $"%submit"

func _ready():
	address_input.value = IP.get_local_addresses()[0]
	submit.connect("pressed", self, "_submit")


func _submit():
	var port = port_input.value.to_int()
	emit_signal("submit", port)

	
