extends Control

onready var play: Button = $"%play"
onready var stop: Button = $"%stop"
onready var work_timer: TextEdit = $"%work_timer"
onready var play_timer: TextEdit = $"%play_timer"

func _ready() -> void:
	play.connect("pressed",self,"_on_play_button_pressed")
	stop.connect("pressed",self,"_on_stop_button_pressed")

func _on_play_button_pressed():
	work_timer.switch()
	if work_timer.stopped:
		play_timer.on()
		play.text = "work"
	else:
		play_timer.off()
		play.text = "play"

func _on_stop_button_pressed():
	work_timer.off()
	play_timer.off()
	play.text = "work"
