extends AudioStreamPlayer

func _ready():
	yield(owner,"ready")
	owner.config.connect("audio_file_updated", self, "set_audio_file")
	owner.config.connect("sound_on_updated", self, "set_sound_on")
	owner.config.connect("interval_updated", self, "set_interval")
	owner.config.connect("volume_updated", self, "set_volume")


func set_audio_file(path:String):
	if ResourceLoader.exists(path):
		var stream = load(path)
		if is_instance_valid(stream) and stream is AudioStreamSample:
			self.stream = stream
		else:
			var ogg_stream = AudioStreamOGGVorbis.new()
			var ogg_file = File.new()
			ogg_file.open(path, File.READ)
			ogg_stream.data = ogg_file.get_buffer(ogg_file.get_len())
			ogg_file.close()
			self.stream = ogg_stream


var sound_on : bool = true
func set_sound_on(val:bool):
	sound_on = val
	refresh_volume_db()

var MS_PER_TIC = 1000
func set_interval(val:float):
	MS_PER_TIC = int(val*1000.0)

var volume = 0.0
func set_volume(val:float):
	volume = val
	refresh_volume_db()

func refresh_volume_db():
	if sound_on:
		volume_db = volume
	else:
		volume_db = -80.0
func _process(_delta):
	var ms_now = owner.msec
	var ms_before = owner.msec_before
	check(ms_before, ms_now)

func check(ms_before:int, ms_now:int):
	if owner.is_processing() and ms_before/MS_PER_TIC != ms_now/MS_PER_TIC:
		play()

func _on_tic_time_text_changed(new_text:String):
	set_interval(new_text.to_float())



