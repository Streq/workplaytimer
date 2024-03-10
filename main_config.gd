extends ConfigNode



func get_default_config() -> Dictionary: 
	var save_hint = "Automatically save task progress in case of a sudden crash."
	var log_hint = "Automatically log progress to history, using overwrite. When the current calendar day changes, all task target times will be shortened by the progressed time, and tasks progress will reset to 0. So that progress for the passed day is accounted only for that day and not the following."
	return {
		auto_save = {
			value = {
				enabled = {value = true, hint = save_hint},
				interval_seconds = {value=5.0, hint="interval of time between saves, in seconds"}
			},
			hint = save_hint
		},
		auto_log = {
			value = {
				enabled = {value = true, hint = log_hint},
				interval_seconds = {value=5.0, hint="interval of time between logs, in seconds"}
			},
			hint = log_hint
		}
	}
