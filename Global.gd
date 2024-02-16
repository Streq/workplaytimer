extends Node
tool

#var PATH: String = OS.get_executable_path().get_base_dir()
var PATH: String = "user://"

static func to_text(msec: int)->String:
	var seconds := msec/1000
	var unit_hours = seconds/60/60
	var unit_minutes = (seconds/60)%60
	var unit_seconds = seconds%60
	var unit_dsec = msec%1000/100
	return "%02d:%02d:%02d.%01d" % [unit_hours, unit_minutes, unit_seconds, unit_dsec]
static func to_text_no_sub_sec(msec: int)->String:
	var seconds := msec/1000
	var unit_hours = seconds/60/60
	var unit_minutes = (seconds/60)%60
	var unit_seconds = seconds%60
	return "%02d:%02d:%02d" % [unit_hours, unit_minutes, unit_seconds]


static func to_text_wrap_hours(msec: int)->String:
	var seconds := msec/1000
	var unit_hours = (seconds/60/60)%24
	var unit_minutes = (seconds/60)%60
	var unit_seconds = seconds%60
	var unit_dsec = msec%1000/100
	return "%02d:%02d:%02d.%01d" % [unit_hours, unit_minutes, unit_seconds, unit_dsec]
static func to_text_no_secs(msec: int)->String:
	var seconds := msec/1000
	var unit_hours = seconds/60/60
	var unit_minutes = (seconds/60)%60
	return "%02d:%02d:00" % [unit_hours, unit_minutes]

static func from_text(text:String):

	var vals = text.split(":")
	var secs_dsecs = vals[-1].split(".") if vals.size() > 0 else []

	var unit_hours = int(vals[0]) if vals.size() > 0 else 0
	var unit_minutes = int(vals[1]) if vals.size() > 1 else 0
	var unit_seconds = int(secs_dsecs[0]) if secs_dsecs.size() > 0 else 0
	var unit_dsec = int(secs_dsecs[1]) if secs_dsecs.size() > 1 else 0
	
	var msec = (
		unit_hours*60*60*1000 + 
		unit_minutes*60*1000 + 
		unit_seconds*1000 + 
		unit_dsec*100
	)
	return msec

#static func now_msec():
#	return Time.get_ticks_msec()


static func now_msec() -> int:
	var timezone_offset_minutes = Time.get_time_zone_from_system().bias
	var timezone_offset_seconds = timezone_offset_minutes*60.0
	
	var utc_now_seconds = Time.get_unix_time_from_system()
	var local_now_seconds = utc_now_seconds + timezone_offset_seconds
	var local_now_millis = int(local_now_seconds * 1000)
	return local_now_millis

static func now_msec_utc() -> int:
	return int(Time.get_unix_time_from_system() * 1000)
	
static func now_millis() -> int:
	return int(now_seconds() * 1000)
	
static func now_seconds() -> float:
	return Time.get_unix_time_from_system()
	
