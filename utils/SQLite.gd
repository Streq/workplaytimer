extends Node

# USEFUL TIME FUNCTIONS
"""
SELECT 
	strftime("%s", 'now') as UNIX, 
	julianday('now') as JULIAN_DAY, 
	(julianday('now') - 2440587.5) * 86400 as UNIX_FLOAT, 
	(julianday('now') - 2440587.5) * 86400 * 1000 AS UNIX_FLOAT_MILLIS, 
	(julianday('now') - 2440587.5) * 86400 * 1000 * 1000 AS UNIX_FLOAT_MICROS,
	(julianday('now') - 2440587.5) * 86400 * 1000 * 1000 * 1000 AS UNIX_FLOAT_NANOS,
	cast(((julianday('now') - 2440587.5) * 86400 * 1000) as int) AS UNIX_MILLIS,
	cast(((julianday('now') - 2440587.5) * 86400 * 1000 * 1000) as int) AS UNIX_MICROS,
	cast(((julianday('now') - 2440587.5) * 86400 * 1000 * 1000 * 1000) as int) AS UNIX_NANOS
;
"""




# select interval from INTERVAL_START and INTERVAL_END
static func get_intervals_in_interval(start: int, end: int) -> String:
	return GET_INTERVALS_IN_TIME_FRAME.format({
		"start": start, 
		"end": end
	}, "${_}");
const GET_INTERVALS_IN_TIME_FRAME := """
SELECT 
	(CASE 
		WHEN interval.start < param.start THEN param.start
		ELSE interval.start
		END
	) AS start,
	(CASE 
		WHEN interval.end > param.end THEN param.end
		ELSE interval.end 
		END
	) AS end,
	interval.activity,
	interval.task
FROM interval, 
(SELECT ${start} as start, ${end} as end) as param
WHERE	interval.start <= param.end 
	AND	interval.end >= param.start
"""
