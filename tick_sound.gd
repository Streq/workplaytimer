extends AudioStreamPlayer

#TODO REWORK CONFIG

func _ready():
	owner.connect("ready", self, "initialize", [], CONNECT_ONESHOT)

func initialize():
	var config = owner.config
	config.connect("audio_file_updated", self, "set_audio_file")
	config.connect("sound_on_updated", self, "set_sound_on")
	config.connect("interval_updated", self, "set_interval")
	config.connect("volume_updated", self, "set_volume")
	get_tree().connect("idle_frame", self, "hook", [], CONNECT_ONESHOT)

func hook():
	owner.connect("updated", self, "check")

func set_audio_file(path:String):
	if ResourceLoader.exists(path):
		var stream = load(path)
		if is_instance_valid(stream) and stream is AudioStreamSample:
			self.stream = stream
		else:
			var ogg_stream = AudioStreamOGGVorbis.new()
			var ogg_file = File.new()
			if ogg_file.open(path, File.READ):
				return
			ogg_stream.data = ogg_file.get_buffer(ogg_file.get_len())
			ogg_file.close()
			self.stream = ogg_stream


var sound_on : bool = true
func set_sound_on(val:bool):
	sound_on = val
	refresh_volume_db()

var MS_PER_TIC = 1000
func set_interval(val:float):
	var ms = int(val*1000.0)
	if ms > 0:
		MS_PER_TIC = ms

var volume = 0.0
func set_volume(val:float):
	volume = val
	refresh_volume_db()

func refresh_volume_db():
	if sound_on:
		volume_db = volume
	else:
		volume_db = -80.0

func check():
	if !sound_on or !owner.is_processing():
		return

	var ms_before = owner.msec_before
	var ms_now = owner.msec

	if !ms_before:
		return

	var prev_tic = ms_before/MS_PER_TIC
	var curr_tic = ms_now/MS_PER_TIC

	if prev_tic != curr_tic:
		play()

func _on_tic_time_text_changed(new_text:String):
	set_interval(new_text.to_float())



