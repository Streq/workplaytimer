extends Node
class_name ConfigNode

signal initialized(map)

onready var CONFIG_PATH: String = Global.PATH.plus_file("config").plus_file(owner.name+".json")

var map : ConfigMap = ConfigMap.new()

export var load_from_file := true

# you are supposed to override this function with your config and that's it
func get_default_config() -> Dictionary: 
	return {
		audio_file = "res://assets/sfx/click.wav",
		sound_on = false,
		interval = 1.0,
		volume = 0.0
	}

var initialized := false
func initialize():
	if initialized:
		return
	initialized = true
	var default_config = get_default_config()
	var path = CONFIG_PATH
	map.initialize(default_config, path)
	
	
func _ready():
	map.connect("initialized", self, "_initialized")
	initialize()

func _initialized():
	is_initialized = true
	emit_signal("initialized", map)

var is_initialized = false
var going_to_emit = false
func notify_on_init(node:Object, method:String):
	if !is_initialized:
		connect("initialized", node, method, [], CONNECT_ONESHOT)
		return
	
	node.call(method, map)
	
	if going_to_emit:
		return
	
	going_to_emit = true
	call_deferred("emit_updates")

# common method
static func find_config_and_connect(node: Node, method: String):
	var config : ConfigNode = node.get_node("%config")
	config.notify_on_init(node, method)

func emit_updates():
	map.emit_updates()
	going_to_emit = false

static func entry(value, tooltip:="", control_type = null):
	return {value=value, hint=tooltip, type=control_type}
