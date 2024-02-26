extends Config


func get_default_config() -> Dictionary:
	return {
		audio_file = "res://assets/sfx/click.wav",
		sound_on = false,
		volume = 0.0,
		hide_completed_tasks = false,
		alert_on_task_completed = false,
		play_sound_on_task_completed = true,
		progress_tasks_in_parallel = false,
	}
