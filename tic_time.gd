extends LineEdit
signal changed(val)




func _ready() -> void:
	yield(owner,"ready")
	owner.config.connect("interval_updated",self,"set_interval_internal")
	connect("text_changed",self,"text_changed")
	


var interval : float = 1.0
	
func set_interval_internal(val:float):
	if val > 0.0:
		interval = val
		text = str(val)
		return true
	else:
		return false

func set_interval(val):
	if(set_interval_internal(val)):
		owner.config.set_property("interval",interval)

func text_changed(val:String):
	set_interval(val.to_float())
