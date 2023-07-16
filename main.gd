extends Control

onready var play: Button = $"%play"
onready var stop: Button = $"%stop"
onready var clear: Button = $"%clear"

onready var work_timer: TextEdit = $"%work_timer"
onready var play_timer: TextEdit = $"%play_timer"
onready var expected_finish: TextEdit = $"%expected_finish"
onready var work_goal: TextEdit = $"%work_goal"

func _ready() -> void:
	play.connect("pressed",self,"_on_play_button_pressed")
	stop.connect("pressed",self,"_on_stop_button_pressed")
	clear.connect("pressed",self,"_on_clear_button_pressed")
	_on_clear_button_pressed()

func _on_play_button_pressed():
	work_timer.switch()
	if work_timer.stopped:
		play_timer.on()
		play.text = "work"
	else:
		play_timer.off()
		play.text = "play"
		expected_finish.update_time()

func _on_stop_button_pressed():
	work_timer.off()
	play_timer.off()
	play.text = "work"

func _on_clear_button_pressed():
	work_timer.off()
	play_timer.off()
	
	work_timer.accumulated_time_msec = 0
	work_timer.render_text()
	
	play_timer.accumulated_time_msec = 0
	play_timer.render_text()
	
	work_goal.text = "00:00:00.0"
	work_goal._on_text_changed()
