extends LineEdit
onready var calendar = $"%calendar"

func _ready():
	connect("text_entered", self, "_on_changed", [], CONNECT_DEFERRED)
	
func _on_changed(_text):
	validate()

func validate():
	calendar.selected_date.from_date(text)
	calendar.refresh_data()
	var r = calendar.selected_date.date()
	set("text", r)
