extends Node2D

func _ready():

	var schedulers = [
		# every second friday of the month at 5pm
		Scheduler.new(
			Scheduler.modifiers()\
				.start_of_month()\
				.plus(7).days()\
				.weekday(Scheduler.FRIDAY)\
				.start_of_day()\
				.plus(17).hours(), 
			Scheduler.Modifiers.monthly(), 
			Persistence.unixepoch(["now"]), 
			Persistence.unixepoch(["now", "+1 year"])
		),
		# every thursday at 9am
		Scheduler.new(
			Scheduler.modifiers()\
				.weekday(Scheduler.THURSDAY)\
				.start_of_day()\
				.plus(9).hours(), 
			Scheduler.Modifiers.weekly(), 
			Persistence.unixepoch(["now"]), 
			Persistence.unixepoch(["now", "+1 year"])
		),
		# every other day at 7pm
		Scheduler.new(
			Scheduler.modifiers()\
				.plus(2).days()\
				.start_of_day()\
				.plus(19).hours(), 
			Scheduler.Modifiers.daily(), 
			Persistence.unixepoch(["now"]), 
			Persistence.unixepoch(["now", "+1 year"])
		)
	]
	
	for scheduler in schedulers:
		var dates_until_next_year = scheduler\
			.iterator()\
			.get_until(Persistence.scalar("unixepoch('now', '+1 year', 'start of year')"))

		for date in dates_until_next_year:
			print(Time.get_datetime_dict_from_unix_time(date))
	

