extends ColorRect

var activity : String

func initialize(activity:String, progress:int):
	self.activity = activity
	size_flags_stretch_ratio = progress
