extends Node
class_name Config

signal initialized()

const MyConfigFile = preload("res://utils/config.gd")

onready var CONFIG_PATH: String = Global.PATH.plus_file("config").plus_file(owner.name+".json")

var file : MyConfigFile = MyConfigFile.new()

# you are supposed to override this function with your config and that's it
func get_default_config() -> Dictionary: 
	return {
		audio_file = "res://assets/sfx/click.wav",
		sound_on = false,
		interval = 1.0,
		volume = 0.0
	}

func initialize():
	var default_config = get_default_config()
	var path = CONFIG_PATH
	file.initialize(default_config, path)

func _ready():
	file.connect("initialized", self, "_initialized")

func _initialized():
	emit_signal("initialized")
	is_initialized = true

var is_initialized = false
var going_to_emit = false
func notify_on_init(node:Object, method:String):
	if !is_initialized:
		connect("initialized", node, method, [], CONNECT_ONESHOT)
		return
	
	node.call("method")
	
	if going_to_emit:
		return
	
	going_to_emit = true
	call_deferred("emit_updates")

func emit_updates():
	file.emit_updates()
	
