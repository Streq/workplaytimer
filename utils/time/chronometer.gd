extends Reference
signal updated()

const DeltaTimer = preload("delta_timer.gd")

var dt := DeltaTimer.new()

var msec := 0 setget set_msec
func set_msec(val):
	set_msec_no_signal(val)
	emit_signal("updated")
func set_msec_no_signal(val):
	msec = val

func serialize():
	return {
		msec = msec,
	}
func deserialize(dictionary):
	if !dictionary:
		return
	var dict = serialize()
	dict.merge(dictionary, true)
	set_msec(dict.msec)

func update_and_get():
	set_msec(msec + dt.get_and_reset())
	return msec

func ignore_previous_delta():
	dt.get_and_reset()

func restart():
	dt.get_and_reset()
	msec = 0
