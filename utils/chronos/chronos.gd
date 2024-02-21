extends Object

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
	return int(seconds * 1_000.0)
static func mic(seconds: float) -> int:
	return int(seconds * 1_000_000.0)
static func nan(seconds: float) -> int:
	return int(seconds * 1_000_000_000.0)

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
static func sec_to_text_interval_hhmmssd(sec: float) -> String:
	var unit_dsc = int(fmod(sec, 1.0)*10)
	return sec_to_text_interval_hhmmss(sec)+(".%01d" % [unit_dsc])

static func sec_to_text_time_hhmmss(sec: float) -> String:
	var s = int(sec)
	var unit_hrs = s/3600%24
	var unit_min = s/60%60
	var unit_sec = s%60
	return "%02d:%02d:%02d" % [unit_hrs, unit_min, unit_sec]
static func sec_to_text_time_hhmmssd(sec: float) -> String:
	var unit_dsc = int(fmod(sec, 1.0)*10)
	return sec_to_text_time_hhmmss(sec)+(".%01d" % [unit_dsc])
