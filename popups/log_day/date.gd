extends LineEdit
onready var calendar = $"%calendar"

func _ready():
	connect("text_entered", self, "_on_changed", [], CONNECT_DEFERRED)
	
func _on_changed(text):
	calendar.selected_date.from_date(text)
	calendar.refresh_data()
	var r = calendar.selected_date.date()
	set_deferred("text", r)
