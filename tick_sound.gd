extends AudioStreamPlayer

onready var config : Config = $"%config"
func _ready() -> void:
	config.notify_on_init(self, "initialize")

func initialize():
	config.file.connect("audio_file_updated", self, "set_audio_file")
	config.file.connect("sound_on_updated", self, "set_sound_on")
	config.file.connect("volume_updated", self, "set_volume")
	
	
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
		




