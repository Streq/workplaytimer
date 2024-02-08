extends AudioStreamPlayer


export var MS_PER_TIC := 1000

func _process(delta):
	var ms_now = owner.msec
	var ms_before = owner.msec_before
	check(ms_before, ms_now)

func check(ms_before:int, ms_now:int):
	if owner.is_processing() and ms_before/MS_PER_TIC != ms_now/MS_PER_TIC:
		play()

func _on_tic_time_text_changed(new_text:String):
	var raw_val : float = new_text.to_float()
	var val = int(raw_val*1000.0)
	if val > 0:
		MS_PER_TIC = val
