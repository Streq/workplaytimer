extends ConfigNode


func get_default_config() -> Dictionary:
	return {
		audio_file = "res://assets/sfx/click.wav",
		sound_on = false,
		volume = 0.0,
		hide_completed_tasks = false,
		alert_on_task_completed = false,
		progress_tasks_in_parallel = false,
	}


func get_default_config2() -> Dictionary:
	return {
		sound_on=false,
		play_sound_on_task_completed = {
			value = true,
			hint = "Play a sound when a task is completed.",
		},
		audio_file = {
			value = "res://assets/sfx/click.wav", 
			hint = "Sound to play on task completion", 
#			type = "audio_file"
		},
		volume = {
			value = 0.0, 
			hint = "Volume of the sound to play on task completion.", 
#			type = "volume"
		},
		hide_completed_tasks = {
			value = false, 
			hint = "Hide completed tasks and only show ones in progress",
		},
		alert_on_task_completed = {
			value = false, 
			hint = "Pop up an alert when all selected tasks are completed"
		},
		progress_tasks_in_parallel = {
			value = false,
			hint = "If on, tasks are processed in parallel, that is, when two tasks are active, their time advances simultaneously. Otherwise only the first of the two advances. "
		}
	}
