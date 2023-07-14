extends Control

onready var play: Button = $"%play"
onready var work_timer: TextEdit = $"%work_timer"
onready var play_timer: TextEdit = $"%play_timer"

func _ready() -> void:
	play.connect("pressed",self,"_on_play_button_pressed")

func _on_play_button_pressed():
	work_timer.switch()
	play_timer.switch()
	if work_timer.stopped:
		play.text = "work"
	else:
		play.text = "play"
