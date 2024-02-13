extends LineEdit

func _ready():
	connect("text_entered",self,"_on_text_entered")



func _on_text_entered(new_text):
	var msec = Global.from_text(new_text)
	text = Global.to_text_no_secs(msec)
	
	pass
