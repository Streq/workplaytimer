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
