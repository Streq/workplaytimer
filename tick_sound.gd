extends AudioStreamPlayer

#TODO REWORK CONFIG

func _ready():
	owner.connect("ready", self, "initialize", [], CONNECT_ONESHOT)

func initialize():
	var config = owner.config
	config.connect("audio_file_updated", self, "set_audio_file")
	config.connect("sound_on_updated", self, "set_sound_on")
	config.connect("volume_updated", self, "set_volume")
	config.emit_updates()
	
	
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

var volume = 0.0
func set_volume(val:float):
	volume = val
	refresh_volume_db()

func refresh_volume_db():
	if sound_on:
		volume_db = volume
	else:
		volume_db = -80.0





