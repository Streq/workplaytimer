extends Container
signal submit(date, overwrite)

onready var date = $"%date"
onready var calendar = $"%calendar"
onready var submit = $"%submit"
onready var action = $"%action"

const FORMAT = "YYYY-MM-DD"

func _ready():
	calendar.connect("date_selected",self,"_on_date_selected")
	date.text = calendar.selected_date.date(FORMAT)
	submit.connect("pressed", self, "_on_submit_pressed")
func _on_date_selected(date_obj: Date):
	date.text = date_obj.date(FORMAT)

func _on_submit_pressed():
	date.validate()
	var overwrite = action.text == "Overwrite"
	emit_signal("submit", date.text, overwrite)
