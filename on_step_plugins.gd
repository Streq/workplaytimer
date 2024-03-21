extends Node
signal frame

func _enter_tree():
	SignalUtils.connect_(self, true, "child_entered_tree", self, "_on_child_entered")
	SignalUtils.connect_(self, true, "child_exiting_tree", self, "_on_child_exiting")

func _on_child_entered(child):
	SignalUtils.connect_(self, true, "frame", child, "frame")
func _on_child_exiting(child):
	SignalUtils.connect_(self, false, "frame", child, "frame")

func frame():
	emit_signal("frame")
