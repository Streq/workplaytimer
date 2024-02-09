extends LineEdit
signal changed(val)




func _ready() -> void:
	yield(owner,"ready")
	owner.config.connect("volume_updated",self,"set_volume_internal")
	connect("text_changed",self,"text_changed")
	


var volume : float = 0.0
	
func set_volume_internal(val:float):
	volume = val
	if float(text)!=volume:
		text = str(val)
	
func set_volume(val):
	set_volume_internal(val)
	owner.config.set_property("volume",volume)

func text_changed(val:String):
	set_volume(val.to_float())
