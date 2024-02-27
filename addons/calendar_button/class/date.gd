class_name Date

var day : int setget set_day
var month : int setget set_month
var year : int setget set_year

func _init(day : int = OS.get_datetime()["day"], 
		month : int = OS.get_datetime()["month"], 
		year : int = OS.get_datetime()["year"]):
	self.day = day
	self.month = month
	self.year = year

# Supported Date Formats:
# DD : Two digit day of month
# MM : Two digit month
# YY : Two digit year
func date(date_format := "YYYY-MM-DD") -> String:
	if("DD".is_subsequence_of(date_format)):
		date_format = date_format.replace("DD", str(day).pad_zeros(2))
	if("MM".is_subsequence_of(date_format)):
		date_format = date_format.replace("MM", str(month).pad_zeros(2))
	if("YYYY".is_subsequence_of(date_format)):
		date_format = date_format.replace("YYYY", str(year))
	elif("YY".is_subsequence_of(date_format)):
		date_format = date_format.replace("YY", str(year).substr(2,3))
	return date_format

func from_date(date: String, date_format := "YYYY-MM-DD"):
	if("DD".is_subsequence_of(date_format)):
		day = MathUtils.maxi(1, int(date.substr(date_format.find("DD"), 2)))
	if("MM".is_subsequence_of(date_format)):
		month = MathUtils.maxi(1, int(date.substr(date_format.find("MM"), 2)))
	if("YYYY".is_subsequence_of(date_format)):
		year = MathUtils.maxi(1, int(date.substr(date_format.find("YYYY"), 4)))
	elif("YY".is_subsequence_of(date_format)):
		year = MathUtils.maxi(1, int(date.substr(date_format.find("YY"), 2)))
	


func is_equal(other: Date):
	return year == other.year and month == other.month and day == other.day

func day() -> int:
	return day

func month() -> int:
	return month

func year() -> int:
	return year

func set_day(var _day : int):
	day = _day

func set_month(var _month : int):
	month = _month

func set_year(var _year : int):
	year = _year

func change_to_prev_month():
	var selected_month = month()
	selected_month -= 1
	if(selected_month < 1):
		set_month(12)
		set_year(year() - 1)
	else:
		set_month(selected_month)

func change_to_next_month():
	var selected_month = month()
	selected_month += 1
	if(selected_month > 12):
		set_month(1)
		set_year(year() + 1)
	else:
		set_month(selected_month)

func change_to_prev_year():
	set_year(year() - 1)

func change_to_next_year():
	set_year(year() + 1)
func change_to_today():
	set_day(Calendar.day())
	set_month(Calendar.month())
	set_year(Calendar.year())

func to_days():
	return Calendar.to_days(year, month, day)
