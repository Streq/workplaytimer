extends AudioStreamPlayer

func _ready() -> void:
	ConfigNode.find_config_and_connect(self, "initialize")

func initialize(config: ConfigMap):
	config.on_prop_change_notify_obj("audio_file", self, "set_audio_file")
	config.on_prop_change_notify_obj("sound_on", self, "set_sound_on")
	config.on_prop_change_notify_obj("volume", self, "set_volume")
	
	
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
		volume_db = -100000.0
		




