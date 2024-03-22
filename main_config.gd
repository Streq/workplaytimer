extends ConfigNode



func get_default_config() -> Dictionary: 
	var save_hint = "Automatically save task progress in case of a sudden crash."
	var log_hint = "Automatically log progress to history, using overwrite. When the current calendar day changes, all task target times will be shortened by the progressed time, and tasks progress will reset to 0. So that progress for the passed day is accounted only for that day and not the following."
	var low_process_on_unfocus_hint = "Reduce cpu usage when unfocused by reducing framerate and/or not rendering to screen, timers will advance at the same rate regardless."
	var low_process_on_minimized_hint = "Reduce cpu usage when minimized by reducing framerate and/or not rendering to screen, timers will advance at the same rate regardless."
	var render_hint = "Whether to render to screen"
	var sleep_hint = "Time to sleep between frames"
	return {
		auto_save = {
			value = {
				enabled = {value = true, hint = save_hint},
				interval_seconds = {value = 5.0, hint = "Interval of time between automatic saves, in seconds"}
			},
			hint = save_hint
		},
		auto_log = {
			value = {
				enabled = {value = true, hint = log_hint},
				interval_seconds = {value = 5.0, hint = "Interval of time between automatic logs, in seconds"}
			},
			hint = log_hint
		},
		low_process_on_unfocus = {
			value = {
				enabled = {value = true, hint = low_process_on_unfocus_hint},
				render = {value = true, hint = render_hint},
				sleep_milliseconds = {value = 100, hint = sleep_hint, min_value = 0, max_value = 5000}
			},
			hint = low_process_on_unfocus_hint
		},
		low_process_on_minimized = {
			value = {
				enabled = {value = true, hint = low_process_on_unfocus_hint},
				render = {value = false, hint = render_hint},
				sleep_milliseconds = {value = 500, hint = sleep_hint, min_value = 0, max_value = 5000}
			},
			hint = low_process_on_minimized_hint
		}
		
	}
