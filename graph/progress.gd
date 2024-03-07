extends Control
signal hover(activity, progress)
onready var button = $"%button"

var activity : String setget set_activity
func set_activity(val):
	activity = val

var progress : int setget set_progress
func set_progress(val):
	progress = val
	size_flags_stretch_ratio = progress

func initialize(activity_: String, progress_: int):
	set_activity(activity_)
	set_progress(progress_)

func _ready():
	button.connect("mouse_entered", self, "_mouse_entered")

func _mouse_entered():
	emit_signal("hover", activity, progress)
