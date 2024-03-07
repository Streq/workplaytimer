extends ConfigNode

func get_default_config() -> Dictionary: 
	return {
		auto_save = {
			value = true,
			hint = "Automatically save task progress in case of a sudden crash."
		},
		auto_save_interval_seconds = 5.0,
		auto_log = {
			value = true,
			hint = "Automatically log progress to history, using overwrite. When the current calendar day changes, all task target times will be shortened by the progressed time, and tasks progress will reset to 0."
		},
		auto_log_interval_seconds = 5.0,
		
	}



func get_default_config2() -> Dictionary: 
	return {
		auto_save = {
			value = {
				enabled = true,
				interval_seconds = 5.0
			},
			hint = "Automatically save task progress in case of a sudden crash."
		},
		auto_log = {
			value = {
				enabled = true,
				interval_seconds = 5.0
			},
			hint = "Automatically log progress to history, using overwrite. When the current calendar day changes, all task target times will be shortened by the progressed time, and tasks progress will reset to 0."
		}
	}
