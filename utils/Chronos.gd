extends Object
class_name TimeUtils
func _init():
	var msg = "%s is an utility class, you are not supposed to instantiate it." % get_script().resource_path
	assert(false, msg)
	printerr(msg)

static func tz_offset_min() -> int:
	return Time.get_time_zone_from_system().bias

static func tz_offset_sec() -> int:
	return tz_offset_min()*60
static func tz_offset_mil() -> int:
	return tz_offset_min()*60_000
static func tz_offset_mic() -> int:
	return tz_offset_min()*60_000_000
static func tz_offset_nan() -> int:
	return tz_offset_min()*60_000_000_000

static func local_now_sec() -> float:
	var res = tz_offset_sec() + now_sec()
	return res
static func local_now_mil() -> int:
	var res = tz_offset_mil() + now_mil()
	return res
static func local_now_mic() -> int:
	var res = tz_offset_mic() + now_mic()
	return res
static func local_now_nan() -> int:
	var res = tz_offset_nan() + now_nan()
	return res

static func mil(seconds: float) -> int:
	return int(seconds * 1_000)
static func mic(seconds: float) -> int:
	return int(seconds * 1_000_000)
static func nan(seconds: float) -> int:
	return int(seconds * 1_000_000_000)

static func mil_to_sec(mil: int) -> float:
	return mil * 0.00_1
static func mic_to_sec(mic: int) -> float:
	return mic * 0.00_000_1
static func nan_to_sec(nan: int) -> float:
	return nan * 0.00_000_000_1


static func now_sec() -> float:
	return Time.get_unix_time_from_system()
static func now_mil() -> int:
	return mil(now_sec())
static func now_mic() -> int:
	return mic(now_sec())
static func now_nan() -> int:
	return nan(now_sec())

static func sec_to_text_interval_hhmmss(sec: float) -> String:
	var s = int(sec)
	var unit_hrs = s/3600
	var unit_min = s/60%60
	var unit_sec = s%60
	return "%02d:%02d:%02d" % [unit_hrs, unit_min, unit_sec]
static func mil_to_text_interval_hhmmss(mil: int) -> String:
	var s = mil / 1_000
	return sec_to_text_interval_hhmmss(s)
static func mic_to_text_interval_hhmmss(mic: int) -> String:
	var s = mic / 1_000_000
	return sec_to_text_interval_hhmmss(s)
static func nan_to_text_interval_hhmmss(nan: int) -> String:
	var s = nan / 1_000_000_000
	return sec_to_text_interval_hhmmss(s)

static func sec_to_text_interval_hhmmssd(sec: float) -> String:
	var unit_dsc = int(fmod(sec, 1.0)*10)
	return sec_to_text_interval_hhmmss(sec)+(".%01d" % [unit_dsc])
static func mil_to_text_interval_hhmmssd(mil: int) -> String:
	var s = mil_to_sec(mil)
	return sec_to_text_interval_hhmmssd(s)
static func mic_to_text_interval_hhmmssd(mic: int) -> String:
	var s = mic_to_sec(mic)
	return sec_to_text_interval_hhmmssd(s)
static func nan_to_text_interval_hhmmssd(nan: int) -> String:
	var s = nan_to_sec(nan)
	return sec_to_text_interval_hhmmssd(s)

static func sec_to_text_time_hhmmss(sec: int) -> String:
	var s = sec
	var unit_hrs = s/3600%24
	var unit_min = s/60%60
	var unit_sec = s%60
	return "%02d:%02d:%02d" % [unit_hrs, unit_min, unit_sec]
static func mil_to_text_time_hhmmss(mil: int) -> String:
	var s = mil / 1_000
	return sec_to_text_time_hhmmss(s)
static func mic_to_text_time_hhmmss(mic: int) -> String:
	var s = mic / 1_000_000
	return sec_to_text_time_hhmmss(s)
static func nan_to_text_time_hhmmss(nan: int) -> String:
	var s = nan / 1_000_000_000
	return sec_to_text_time_hhmmss(s)

static func sec_to_text_time_hhmmssd(sec: float) -> String:
	var unit_dsc = int(fmod(sec, 1.0)*10)
	return sec_to_text_time_hhmmss(int(sec))+(".%01d" % [unit_dsc])
static func mil_to_text_time_hhmmssd(mil: int) -> String:
	var sec = mil_to_sec(mil)
	var unit_dsc = int(fmod(sec, 1.0)*10)
	return sec_to_text_time_hhmmss(sec)+(".%01d" % [unit_dsc])
static func mic_to_text_time_hhmmssd(mic: int) -> String:
	var sec = mic_to_sec(mic)
	var unit_dsc = int(fmod(sec, 1.0)*10)
	return sec_to_text_time_hhmmss(sec)+(".%01d" % [unit_dsc])
static func nan_to_text_time_hhmmssd(nan: int) -> String:
	var sec = nan_to_sec(nan)
	var unit_dsc = int(fmod(sec, 1.0)*10)
	return sec_to_text_time_hhmmss(sec)+(".%01d" % [unit_dsc])
static func hhmmssd_to_sec(text:String) -> float:
	var e := Expression.new()
	
	var expressions := text.split(":")
	var size = min(expressions.size(), 3)
	
	var vals = PoolRealArray()
	vals.resize(3)
	vals.fill(0.0)
	for i in size:
		var expression := expressions[size-1-i]
		
		var error := e.parse(expression)
		var res
		if error:
			res = expression
		else:
			res = e.execute()
			if e.has_execute_failed() or !((res is int) or (res is float)):
				res = expression
		
		vals[3-1-i] = float(res)

	var ret = vals[0]*3600.0 + vals[1]*60.0 + vals[2]
	
	return ret

static func hhmmssd_to_mil_old(text:String):

	var vals = text.split(":")
	var secs_dsecs = vals[-1].split(".") if vals.size() > 0 else []

	var unit_hours = int(vals[0]) if vals.size() > 0 else 0
	var unit_minutes = int(vals[1]) if vals.size() > 1 else 0
	var unit_seconds = int(secs_dsecs[0]) if secs_dsecs.size() > 0 else 0
	var unit_dsec = int(secs_dsecs[1]) if secs_dsecs.size() > 1 else 0
	
	var msec = (
		unit_hours*36_00_000 + 
		unit_minutes*60_000 + 
		unit_seconds*1_000 + 
		unit_dsec*100
	)
	return msec

static func hhmmssd_to_mil(text:String) -> int:
	return mil(hhmmssd_to_sec(text))
static func hhmmssd_to_mic(text:String) -> int:
	return mic(hhmmssd_to_sec(text))
static func hhmmssd_to_nan(text:String) -> int:
	return nan(hhmmssd_to_sec(text))


