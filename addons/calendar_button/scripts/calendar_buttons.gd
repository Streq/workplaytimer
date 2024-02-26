class_name CalendarButtons

const BUTTONS_COUNT = 42
var buttons_container : GridContainer

func _init(var calendar_script, var buttons_container : GridContainer):
	self.buttons_container = buttons_container
	setup_button_signals(calendar_script)

func setup_button_signals(var calendar_script):
	for i in range(BUTTONS_COUNT):
		var btn_node = buttons_container.get_node("btn_" + str(i))
		btn_node.connect("pressed", calendar_script, "day_selected", [btn_node])

func update_calendar_buttons(var selected_date : Date, month: int, year: int):
	_clear_calendar_buttons()
	
	var days_in_month : int = Calendar.get_days_in_month(month, year)
	var start_day_of_week : int = Calendar.get_weekday(1, month, year)
	for i in range(days_in_month):
		var btn_node : Button = buttons_container.get_node("btn_" + str(i + start_day_of_week))
		btn_node.set_text(str(i + 1))
		btn_node.set_disabled(false)
		btn_node.modulate = Color.white
		
		# today
		if i + 1 == Calendar.day() and year == Calendar.year() && month == Calendar.month():
			btn_node.modulate = Color.yellow
		
		# selected date
		if i + 1 == selected_date.day() and selected_date.year() == year and selected_date.month() == month:
			btn_node.disabled = true
			btn_node.flat = true
		else:
			btn_node.disabled = false
			btn_node.flat = false

func _clear_calendar_buttons():
	for i in range(BUTTONS_COUNT):
		var btn_node : Button = buttons_container.get_node("btn_" + str(i))
		btn_node.set_text("")
		btn_node.set_disabled(true)
		btn_node.set_flat(false)
