extends AudioStreamPlayer

func _ready():
	yield(owner,"ready")
	owner.config.connect("audio_file_updated", self, "set_audio_file")
	owner.config.connect("sound_on_updated", self, "set_sound_on")
	owner.config.connect("interval_updated", self, "set_interval")


func set_audio_file(path:String):
	var file = load(path)
	if is_instance_valid(file) and file is AudioStreamSample:
		var sample : AudioStreamSample = file
		self.stream = sample


var sound_on : bool = true
func set_sound_on(val:bool):
	sound_on = val
	if sound_on:
		volume_db = 0.0
	else:
		volume_db = -80.0

var MS_PER_TIC = 1000
func set_interval(val:int):
	MS_PER_TIC = int(val*1000.0)


func _process(delta):
	var ms_now = owner.msec
	var ms_before = owner.msec_before
	check(ms_before, ms_now)

func check(ms_before:int, ms_now:int):
	if owner.is_processing() and ms_before/MS_PER_TIC != ms_now/MS_PER_TIC:
		play()

func _on_tic_time_text_changed(new_text:String):
	set_interval(new_text.to_float())



