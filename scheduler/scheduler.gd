class_name Scheduler extends Reference
var offset_modifiers : PoolStringArray
var scheduled_modifiers : PoolStringArray

var start := 0
var end := 0

func _init(scheduler: Modifiers, offset: Modifiers, unixepoch_start: int = 0, unixepoch_end: int = 0):
	scheduled_modifiers = scheduler.build()
	offset_modifiers = offset.build()
	start = unixepoch_start
	end = unixepoch_end

func iterator(unixepoch : int = 0) -> Iterator:
	return Iterator.new(self, unixepoch)

func next_scheduled(current_unixepoch : int) -> int:
	if start and start > current_unixepoch:
		current_unixepoch = start

	var result_unixepoch = scheduled(current_unixepoch)
	while result_unixepoch <= current_unixepoch:
		result_unixepoch = offset(result_unixepoch)
		result_unixepoch = scheduled(result_unixepoch)
	
	if end and end < result_unixepoch:
		return -1
	
	return result_unixepoch
	
func offset(current_unixepoch : int) -> int:
	return unixepoch(current_unixepoch, offset_modifiers)

func scheduled(current_unixepoch : int) -> int:
	return unixepoch(current_unixepoch, scheduled_modifiers)

func unixepoch(current_unixepoch: int, modifiers: PoolStringArray):
	return Persistence.unixepoch_from(current_unixepoch, modifiers)

static func modifiers() -> Modifiers:
	return Modifiers.new()


enum Unit {
	YEARS,
	MONTHS,
	DAYS,
	HOURS,
	MINUTES,
	SECONDS
}

enum {
	SUNDAY = 0,
	MONDAY,
	TUESDAY,
	WEDNESDAY,
	THURSDAY,
	FRIDAY,
	SATURDAY
}

enum {
	JANUARY = 1,
	FEBRUARY,
	MARCH,
	APRIL,
	MAY,
	JUNE,
	JULY,
	AUGUST,
	SEPTEMBER,
	OCTOBER,
	NOVEMBER,
	DECEMBER,
}

class Iterator:
	var current := 0
	var next := 0
	var scheduler : Scheduler
	func _init(scheduler: Scheduler, unixepoch := 0):
		self.scheduler = scheduler
		self.current = unixepoch
	func peek() -> int:
		has_next()
		return next
	func next() -> int:
		has_next()
		current = next
		return next
	func has_next() -> bool:
		if next <= current:
			next = scheduler.next_scheduled(current)
		return next > current
	func get_until(unixepoch: int) -> PoolIntArray:
		var ret := PoolIntArray()
		while has_next() and next < unixepoch:
			ret.append(next())
		return ret

const MODIFIER_FORMAT = "%s"

class Modifiers:
	var args = PoolStringArray()
	var sign_ : int = 0
	var amount = 0
	
	func build() -> PoolStringArray:
		return args
	func _push(arg: String):
		if sign_ == 0:
			args.push_back(MODIFIER_FORMAT % arg)
			amount = 0.0
			return self
		
		match arg[0]:
			"+":
				arg = arg.substr(1)
			"-":
				arg = arg.substr(1)
				sign_ *= -1
			_:
				pass
			
		var operator := "+"
		if sign_ < 0:
			operator = "-"
			
		arg = operator + arg
			
		sign_ = 0
		amount = 0.0
		args.push_back(MODIFIER_FORMAT % arg)
		return self
	func unit(unit):
		match typeof(unit):
			TYPE_STRING:
				return unit_s(unit)
			_:
				return unit_i(unit)
	func unit_s(unit: String) -> Modifiers:
		_push("%s %s" % [str(0 if !amount else amount), unit.to_lower()]) 
		return self
	func unit_i(unit: int) -> Modifiers:
		return unit_s(Unit.keys()[unit]) 

	
	func years():
		return unit_s("years")
	func year():
		return unit_s("year")
	func months():
		return unit_s("months")
	func month():
		return unit_s("month")
	func days():
		return unit_s("days")
	func day():
		return unit_s("day")
	func hours():
		return unit_s("hours")
	func hour():
		return unit_s("hour")
	func minutes():
		return unit_s("minutes")
	func minute():
		return unit_s("minute")
	func seconds():
		return unit_s("seconds")
	func second():
		return unit_s("second")



	func plus(amount = null) -> Modifiers:
		self.amount = amount
		if !sign_:
			sign_ = 1
		return self
	func minus(amount) -> Modifiers:
		plus(amount)
		sign_ *= -1
		return self
	#±HH:MM
	func HHMM(hour: int, minute: int) -> Modifiers:
		return _push(_HHMM(hour, minute))
		
	#±HH:MM:SS
	func HHMMSS(hour: int, minute: int, second: int) -> Modifiers:
		return _push(_HHMMSS(hour, minute, second))
		
	#±HH:MM:SS.SSS
	func HHMMSSsss(hour: int, minute: int, second: float) -> Modifiers:
		return _push(_HHMMSSsss(hour, minute, second))

	#±YYYY-MM-DD
	func YYYYMMDD(year: int, month: int, day: int) -> Modifiers:
		return _push(_YYYYMMDD(year, month, day))
	#±YYYY-MM-DD HH:MM
	func YYYYMMDDHHMM(year: int, month: int, day: int, hour: int, minute: int) -> Modifiers:
		return _push(_YYYYMMDDHHMM(year, month, day, hour, minute))
	#±YYYY-MM-DD HH:MM:SS
	func YYYYMMDDHHMMSS(year: int, month: int, day: int, hour: int, minute: int, second: int) -> Modifiers:
		return _push(_YYYYMMDDHHMMSS(year, month, day, hour, minute, second))
	#±YYYY-MM-DD HH:MM:SS.SSS
	func YYYYMMDDHHMMSSsss(year: int, month: int, day: int, hour: int, minute: int, second: float) -> Modifiers:
		return _push(_YYYYMMDDHHMMSSsss(year, month, day, hour, minute, second))
	#start of month
	func start_of_month() -> Modifiers:
		return _push("start of month")
	#start of year
	func start_of_year() -> Modifiers:
		return _push("start of year")
	#start of day
	func start_of_day() -> Modifiers:
		return _push("start of day")
	#weekday N
	func weekday(n: int) -> Modifiers:
		return _push("weekday %d" % n)
	#unixepoch
	func unixepoch() -> Modifiers:
		return _push("unixepoch")
	#julianday
	func julianday() -> Modifiers:
		return _push("julianday")
	#auto
	func auto() -> Modifiers:
		return _push("auto")
	#localtime
	func localtime() -> Modifiers:
		return _push("localtime")
	#utc
	func utc() -> Modifiers:
		return _push("utc")
	#subsec
	func subsec() -> Modifiers:
		return _push("subsec")
	#subsecond
	func subsecond() -> Modifiers:
		return _push("subsecond")
	func literal(val: String) -> Modifiers:
		return _push(val)
	func now() -> Modifiers:
		return _push("now")
	
	#NNN days
	static func _days(val: float)->String:
		return str(val)+" days"
	#NNN hours
	static func _hours(val: float)->String:
		return str(val)+" hours"
	#NNN minutes
	static func _minutes(val: float)->String:
		return str(val)+" minutes"
	#NNN seconds
	static func _seconds(val: float)->String:
		return str(val)+" seconds"
	#NNN months
	static func _months(val: float)->String:
		return str(val)+" months"
	#NNN years
	static func _years(val: float)->String:
		return str(val)+" years"
	#±HH:MM
	static func _HHMM(hour:int, minute: int)->String:
		return "%02d:%02d" % [hour, minute]
	#±HH:MM:SS
	static func _HHMMSS(hour:int, minute: int, second: int)->String:
		return "%02d:%02d:%02d" % [hour, minute, second]
	#±HH:MM:SS.SSS
	static func _HHMMSSsss(hours:int, minutes: int, seconds: float)->String:
		return "%02d:%02d:%06.3f" % [hours, minutes, seconds]
		
	#±YYYY-MM-DD
	static func _YYYYMMDD(year: int, month: int, day: int)->String:
		return "%04d-%02d-%02d" % [year, month, day]
	#±YYYY-MM-DD HH:MM
	static func _YYYYMMDDHHMM(year: int, month: int, day: int, hour: int, minute: int)->String:
		return "%s %s" % [_YYYYMMDD(year, month, day), _HHMM(hour, minute)]
	#±YYYY-MM-DD HH:MM:SS
	static func _YYYYMMDDHHMMSS(year: int, month: int, day: int, hour: int, minute: int, second: int)->String:
		return "%s %s" % [_YYYYMMDD(year, month, day), _HHMMSS(hour, minute, second)]
	#±YYYY-MM-DD HH:MM:SS.SSS
	static func _YYYYMMDDHHMMSSsss(year: int, month: int, day: int, hour: int, minute: int, second: float)->String:
		return "%s %s" % [_YYYYMMDD(year, month, day), _HHMMSSsss(hour, minute, second)]

	# skip the rest of the day
	static func daily() -> Modifiers:
		return Modifiers.new().start_of_day().plus(1).days()
	# skip to next sunday
	static func weekly() -> Modifiers:
		return Modifiers.new().start_of_day().plus(1).day().weekday(0)
	# skip the rest of the month
	static func monthly() -> Modifiers:
		return Modifiers.new().start_of_month().plus(1).months()
	# skip the rest of the year
	static func yearly() -> Modifiers:
		return Modifiers.new().start_of_year().plus(1).years()
