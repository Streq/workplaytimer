extends Slider

onready var debug_volume = $"%debug_volume"
onready var sound = $"%sound"
var config : ConfigMap

func _ready() -> void:
	ConfigNode.find_config_and_connect(self, "initialize")

func initialize(config_: ConfigMap):
	config = config_
	config.on_prop_change_notify_obj("volume", self, "set_volume_internal")
	connect("value_changed", self, "value_changed")
	connect("drag_ended", self, "_on_drag_ended")
	
func _on_drag_ended(_val):
	sound.play()
	
func set_volume_internal(db: float):
	if to_volume(value) != db:
		value = to_value(db)
	
func set_volume(db: float):
	set_volume_internal(db)
	config.set_property("volume", db)

func value_changed(value:float):
	var db = to_volume(value)
	set_volume(db)
	debug_volume.value = db
	

func to_value(db: float):
	var exp_value = range_lerp(db, -80.0, 0.0, 100.0, 20.0) 
	var ratio = log_lerp_inverse(100.0, 20.0, exp_value)
	var value = ratio*100.0

#	print("db: {db}, exp_value: {exp_value}, to_value: ratio: {ratio}, value: {value}".format({
#		"value":str(value),
#		"ratio":str(ratio),
#		"exp_value":str(exp_value),
#		"db":str(db)
#	}))

	return value

func to_volume(value: float):
	var ratio = value/100.0
	var exp_value = log_lerp(100.0, 20.0, ratio)
	var db = range_lerp(exp_value, 100.0, 20.0, -80.0, 0.0)
	
#	print("to_volume: value: {value}, ratio: {ratio}, exp_value: {exp_value}, db: {db}".format({
#		"value":str(value),
#		"ratio":str(ratio),
#		"exp_value":str(exp_value),
#		"db":str(db)
#	}))

	return db

static func log_lerp(from, to, weight):
	var exp_from = log(from)
	var exp_to = log(to)
	var v = exp(lerp(exp_from, exp_to, weight))
	return v

static func log_lerp_inverse(from, to, v):
	var exp_from = log(from)
	var exp_to = log(to)
	var weight = inverse_lerp(exp_from, exp_to, log(v))
	return weight
