tool
extends TextureButton

signal date_selected(date_obj)

var selected_date := Date.new()
var browsed_date := Date.new()
var window_restrictor := WindowRestrictor.new()

var popup : Popup
var calendar_buttons : CalendarButtons



func _enter_tree():
	set_toggle_mode(true)
	setup_calendar_icon()
	popup = create_popup_scene()
	calendar_buttons = create_calendar_buttons()
	setup_month_and_year_signals(popup)
	refresh_data()
	connect("visibility_changed", self, "_on_visibility_changed")
	popup.connect("focus_exited", self, "close_popup")
	popup.connect("visibility_changed", self, "_on_visibility_changed")
	popup.connect("confirmed", self, "select_day")
func _on_visibility_changed():
	if !self.is_visible_in_tree() or !popup.is_visible_in_tree():
		close_popup()

func setup_calendar_icon():
	set_normal_texture(preload("res://addons/calendar_button/btn_img/btn_32x32_03.png"))
	set_normal_texture(preload("res://addons/calendar_button/btn_img/btn_32x32_04.png"))
	
func create_popup_scene() -> Popup:
	return preload("res://addons/calendar_button/popup.tscn").instance() as Popup

func create_calendar_buttons() -> CalendarButtons:
	var calendar_container : GridContainer = popup.get_node("PanelContainer/vbox/hbox_days")
	return CalendarButtons.new(self, calendar_container)

func setup_month_and_year_signals(popup : Popup):
	popup.get_node("%button_prev_month").connect("pressed", self, "go_prev_month")
	popup.get_node("%button_next_month").connect("pressed", self, "go_next_month")
	popup.get_node("%button_prev_year").connect("pressed", self, "go_prev_year")
	popup.get_node("%button_next_year").connect("pressed", self, "go_next_year")
	popup.get_node("%button_today").connect("pressed", self, "go_today")

func set_popup_title(title : String):
	var label_month_year_node := popup.get_node("PanelContainer/vbox/hbox_month_year/label_month_year") as Label
	label_month_year_node.set_text(title)

func select_day():
	pass

func refresh_data():
	var month = browsed_date.month()
	var year = browsed_date.year()
	var title : String = str(Calendar.get_month_name(month) + " " + str(year))
	set_popup_title(title)
	calendar_buttons.update_calendar_buttons(selected_date, month, year)

func day_selected(btn_node):
	var day := int(btn_node.get_text())
	selected_date.set_day(day)
	selected_date.set_month(browsed_date.month())
	selected_date.set_year(browsed_date.year())
	refresh_data()
	emit_signal("date_selected", selected_date)

func go_prev_month():
	browsed_date.change_to_prev_month()
	refresh_data()

func go_next_month():
	browsed_date.change_to_next_month()
	refresh_data()

func go_prev_year():
	browsed_date.change_to_prev_year()
	refresh_data()

func go_next_year():
	browsed_date.change_to_next_year()
	refresh_data()

func go_today():
	browsed_date.change_to_today()
	selected_date.change_to_today()
	refresh_data()
	emit_signal("date_selected", selected_date)

func close_popup():
	popup.hide()
	set_pressed(false)

func _toggled(is_pressed):
	if(!has_node("popup")):
		add_child(popup)
	if(!is_pressed):
		close_popup()
	else:
		if(!has_node("popup")):
			add_child(popup)
		window_restrictor.restrict_popup_inside_screen(popup)
		popup.popup_centered()
