extends Node2D
const Chronos = preload("../chronos.gd")

func padr(text:String, to_length:int, s := " "):
	if text.length()>=to_length:
		return text
	return text + s.repeat(to_length - text.length())

func padl(text:String, to_length:int, s := " "):
	if text.length()>=to_length:
		return text
	return s.repeat(to_length - text.length()) + text


func p(text: String, v):
	print(padr(text, 50, ".") + str(v))

# Called when the node enters the scene tree for the first time.
func _ready():
	p("now_sec():", Chronos.now_sec())
	p("now_mil():", Chronos.now_mil())
	p("now_mic():", Chronos.now_mic())
	p("now_nan():", Chronos.now_nan())
	print("")
	p("tz_offset_min():", Chronos.tz_offset_min())
	p("tz_offset_sec():", Chronos.tz_offset_sec())
	p("tz_offset_mil():", Chronos.tz_offset_mil())
	p("tz_offset_mic():", Chronos.tz_offset_mic())
	p("tz_offset_nan():", Chronos.tz_offset_nan())
	print("")
	p("local_now_sec():", Chronos.local_now_sec())
	p("local_now_mil():", Chronos.local_now_mil())
	p("local_now_mic():", Chronos.local_now_mic())
	p("local_now_nan():", Chronos.local_now_nan())
	print("")
	var now = Chronos.now_sec()
	p("mil(now):", Chronos.mil(now))
	p("mic(now):", Chronos.mic(now))
	p("nan(now):", Chronos.nan(now))
	print("")
	var local_now = Chronos.local_now_sec()
	p("mil(local_now):", Chronos.mil(local_now))
	p("mic(local_now):", Chronos.mic(local_now))
	p("nan(local_now):", Chronos.nan(local_now))
	print("")
	p("sec_to_text_time_hhmmss(now):", Chronos.sec_to_text_time_hhmmss(now))
	p("sec_to_text_time_hhmmssd(now):", Chronos.sec_to_text_time_hhmmssd(now))
	print("")
	p("sec_to_text_time_hhmmss(local_now):", Chronos.sec_to_text_time_hhmmss(local_now))
	p("sec_to_text_time_hhmmssd(local_now):", Chronos.sec_to_text_time_hhmmssd(local_now))
	print("")
	p("sec_to_text_interval_hhmmss(now):", Chronos.sec_to_text_interval_hhmmss(now))
	p("sec_to_text_interval_hhmmssd(now):", Chronos.sec_to_text_interval_hhmmssd(now))
	print("")
	p("sec_to_text_interval_hhmmss(local_now):", Chronos.sec_to_text_interval_hhmmss(local_now))
	p("sec_to_text_interval_hhmmssd(local_now):", Chronos.sec_to_text_interval_hhmmssd(local_now))
	print("")
	get_tree().quit(0)
