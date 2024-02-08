extends Control

onready var play: Button = $"%play"
onready var stop: Button = $"%stop"
onready var clear: Button = $"%clear"
onready var freeze: Button = $"%freeze"

onready var timers: GridContainer = $"%timers"

onready var work_timer: TimeLabel = $"%work_timer"
onready var play_timer: TimeLabel = $"%play_timer"
onready var expected_finish: TimeLabel = $"%expected_finish"
onready var work_goal: TimeLabel = $"%work_goal"
onready var now: TimeLabel = $"%now"

func _ready() -> void:
	play.connect("pressed",self,"_on_play_button_pressed")
	stop.connect("pressed",self,"_on_stop_button_pressed")
	clear.connect("pressed",self,"_on_clear_button_pressed")
	freeze.connect("pressed",self,"_on_freeze_button_pressed")
	initialize()

func _on_play_button_pressed():
	unfreeze()
	set_stop(false)
	work_timer.switch()
	if work_timer.stopped:
		play_timer.on()
		play.text = "work"
	else:
		play_timer.off()
		play.text = "play"
		expected_finish.update_time()

var stop_pressed = false
func _on_stop_button_pressed():
	set_stop(!stop_pressed)
	
func set_stop(val):
	unfreeze()
	stop_pressed = val
	work_timer.set_frozen(stop_pressed)
	play_timer.set_frozen(stop_pressed)
	stop.pressed = stop_pressed

func _on_freeze_button_pressed():
	if frozen:
		unfreeze()
	else:
		freeze()

var frozen = false

func freeze():
	set_stop(false)
	frozen = true
#	freeze.text = "thaw"
	freeze.pressed = true
	for timer in timers.get_children():
		timer.freeze()
		
func unfreeze():
	frozen = false
#	freeze.text = "freeze"
	freeze.pressed = false
	for timer in timers.get_children():
		timer.unfreeze()


func _on_clear_button_pressed():
	work_timer.off()
	play_timer.off()
	
	work_timer.msec = 0
	work_timer.render_text()
	
	play_timer.msec = 0
	play_timer.render_text()
	
	work_goal.msec = 0
	work_goal.render_text()

func initialize():
	work_timer.off()
	play_timer.off()
	
	work_timer.render_text()
	
	play_timer.render_text()
	
	work_goal.render_text()
