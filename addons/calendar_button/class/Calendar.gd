class_name Calendar

enum Month { JAN = 1, FEB = 2, MAR = 3, APR = 4, MAY = 5, JUN = 6, JUL = 7,
		AUG = 8, SEP = 9, OCT = 10, NOV = 11, DEC = 12 }

const MONTH_NAME = [ 
		"Jan", "Feb", "Mar", "Apr", 
		"May", "Jun", "Jul", "Aug", 
		"Sep", "Oct", "Nov", "Dec" ]

const WEEKDAY_NAME = [ 
		"Sunday", "Monday", "Tuesday", "Wednesday", 
		"Thursday", "Friday", "Saturday" ]

static func get_days_in_month(month : int, year : int) -> int:
	var number_of_days : int
	if(month == Month.APR || month == Month.JUN || month == Month.SEP
			|| month == Month.NOV):
		number_of_days = 30
	elif(month == Month.FEB):
		var is_leap_year = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
		if(is_leap_year):
			number_of_days = 29
		else:
			number_of_days = 28
	else:
		number_of_days = 31
	
	return number_of_days

static func get_weekday(day : int, month : int, year : int) -> int:
	var t : Array = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4]
	if(month < 3):
		year -= 1
	return (year + year/4 - year/100 + year/400 + t[month - 1] + day) % 7

static func get_weekday_name(day : int, month : int, year : int) -> String:
	var day_num = get_weekday(day, month, year)
	return WEEKDAY_NAME[day_num]

static func get_month_name(month : int) -> String:
	return MONTH_NAME[month - 1]

static func hour() -> int:
	return OS.get_datetime()["hour"]

static func minute() -> int:
	return OS.get_datetime()["minute"]

static func second() -> int:
	return OS.get_datetime()["second"]

static func day() -> int:
	return OS.get_datetime()["day"]

static func weekday() -> int:
	return OS.get_datetime()["weekday"]

static func month() -> int:
	return OS.get_datetime()["month"]

static func year() -> int:
	return OS.get_datetime()["year"]

static func daylight_savings_time() -> int:
	return dst()

static func dst() -> int:
	return OS.get_datetime()["dst"]

static func to_days(y:int, m:int, d:int) -> int:
	m = (m + 9) % 12
	y = y - m/10
	return 365*y + y/4 - y/100 + y/400 + (m*306 + 5)/10 + ( d - 1 )
static func to_days_arr(arr:Array) -> int:
	return to_days(arr[0], arr[1], arr[2])

static func from_days(g: int) -> Array:
	var y = (10000*g + 14780)/3652425
	var ddd = g - (365*y + y/4 - y/100 + y/400)
	if ddd < 0:
		y = y - 1
		ddd = g - (365*y + y/4 - y/100 + y/400)
	 
	var mi = (100*ddd + 52)/3060
	var mm = (mi + 2)%12 + 1
	y = y + (mi + 2)/12
	var dd = ddd - (mi*306 + 5)/10 + 1
	return [y, mm, dd]

static func date_to_string(year:int, month: int, day: int, date_format := "YYYY-MM-DD") -> String:
	if("DD".is_subsequence_of(date_format)):
		date_format = date_format.replace("DD", str(day).pad_zeros(2))
	if("MM".is_subsequence_of(date_format)):
		date_format = date_format.replace("MM", str(month).pad_zeros(2))
	if("YYYY".is_subsequence_of(date_format)):
		date_format = date_format.replace("YYYY", str(year))
	elif("YY".is_subsequence_of(date_format)):
		date_format = date_format.replace("YY", str(year).substr(2,3))
	return date_format

static func date_to_string_arr(arr: Array, date_format := "YYYY-MM-DD") -> String:
	var year: int = arr[0]
	var month: int = arr[1]
	var day: int = arr[2]
	return date_to_string(year, month, day, date_format)

static func string_to_date(date: String, date_format := "YYYY-MM-DD") -> Array:
	var year:int
	var month:int
	var day:int
	if("DD".is_subsequence_of(date_format)):
		day = MathUtils.maxi(1, int(date.substr(date_format.find("DD"), 2)))
	if("MM".is_subsequence_of(date_format)):
		month = MathUtils.maxi(1, int(date.substr(date_format.find("MM"), 2)))
	if("YYYY".is_subsequence_of(date_format)):
		year = MathUtils.maxi(1, int(date.substr(date_format.find("YYYY"), 4)))
	elif("YY".is_subsequence_of(date_format)):
		year = MathUtils.maxi(1, int(date.substr(date_format.find("YY"), 2)))
	return [year, month, day]

static func days_to_string(days: int, date_format := "YYYY-MM-DD") -> String:
	return date_to_string_arr(from_days(days), date_format)
static func string_to_days(date: String, date_format := "YYYY-MM-DD") -> int:
	return to_days_arr(string_to_date(date, date_format))


static func today_to_string(date_format := "YYYY-MM-DD") -> String:
	return date_to_string(year(), month(), day(), date_format)
