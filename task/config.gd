extends ConfigNode

func get_default_config() -> Dictionary: 
	return {
		open_ended = {
			value = false,
			hint = """
				If true, this task will not "finish"
				after its time is reached, but rather when manually set
				by pressing the corresponding 'Done' button. This setting is 
				helpful for distinguishing between concrete tasks that can be
				estimated to take a certain amount of time but can't be known 
				for sure, and tasks that are rather "activities" you want to 
				work on for a fixed amount of time.
				"""
		},
		delete_on_done = false
	}
