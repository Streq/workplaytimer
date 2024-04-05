extends Node2D
const CONSTANTS = {
	JULIAN_DAY = "julianday('now')",

	UNIX_SEC = "strftime('%s', 'now')",
	UNIX_MIL = "cast(((julianday('now') - 2440587.5) * 86400 * 1000) as int)",
	UNIX_MIC = "cast(((julianday('now') - 2440587.5) * 86400 * 1000 * 1000) as int)",
	UNIX_NAN = "cast(((julianday('now') - 2440587.5) * 86400 * 1000 * 1000 * 1000) as int)",

	UNIX_SEC_F = "(julianday('now') - 2440587.5) * 86400", 
	UNIX_MIL_F = "(julianday('now') - 2440587.5) * 86400 * 1000", 
	UNIX_MIC_F = "(julianday('now') - 2440587.5) * 86400 * 1000 * 1000",
	UNIX_NAN_F = "(julianday('now') - 2440587.5) * 86400 * 1000 * 1000 * 1000",
}

const GET_TIME = """
SELECT (a - b)
FROM (
	SELECT SUM("timestamp") as a 
	FROM activity_log
	WHERE is_begin == 0
	AND activity == {activity_id}
),(
	SELECT SUM("timestamp") as b 
	FROM activity_log
	WHERE is_begin == 1
	AND activity == {activity_id}
)
"""

const LOG_VIEW = """
WITH numbered_logs AS (
	SELECT
		*,
		ROW_NUMBER() OVER (ORDER BY activity, timestamp) AS row_num
	FROM activity_log
)
SELECT ac.name, a.timestamp AS start, b.timestamp AS end, b.timestamp - a.timestamp as duration
FROM (
	SELECT 
		row_num, timestamp, activity
	FROM numbered_logs
	WHERE row_num % 2 = 1 -- Select odd row numbers
) a
JOIN (
	SELECT 
		row_num, timestamp, activity
	FROM numbered_logs
	WHERE row_num % 2 = 0 -- Select even row numbers
) b ON a.row_num + 1 = b.row_num and a.activity = b.activity -- Join even row numbers with odd row numbers
JOIN activity ac
ON a.activity = ac.id
;
"""


const tables = {
	activity = {
		id = {
			data_type = "int", 
			primary_key = true, 
			auto_increment = true
		},
		name = {
			data_type= "CHAR(255)",
		}
	},
	activity_log = {
		timestamp = {
			data_type = "int"
		},
		activity = {
			data_type = "int",
			foreign_key = "activity.id"
		}
	}
}


func _ready():
	test2()
	get_tree().quit(0)


const test_db_file = "user://test.db"
func test2():
	FileUtils.delete(test_db_file)
	
	var s := SQLiteWrapper.new()
	
	s.set_path(test_db_file)
	s.set_foreign_keys(true)
	
	s.verbosity_level = 2
	s.open_db()
	s.query(Schema.DEFINITION)
	s.query(Schema.TEST_DATA_INSERT)
	s.query("""
		SELECT *
		FROM activity_progress;
	""")
	pretty_print_res(s.get_query_result())
	
	s.query("""
		SELECT *
		FROM task_progress;
	""")
	pretty_print_res(s.get_query_result())
	s.query("""
		SELECT *
		FROM interval;
	""")
	pretty_print_res(s.get_query_result())
	s.query("""
		SELECT *
		FROM closed_interval;
	""")
	pretty_print_res(s.get_query_result())
	s.query("""
		SELECT *
		FROM open_interval;
	""")
	pretty_print_res(s.get_query_result())

	s.query("""
		SELECT *
		FROM task;
	""")
	pretty_print_res(s.get_query_result())


	s.query("""
		SELECT *
		FROM activity;
	""")
	pretty_print_res(s.get_query_result())

	s.close_db()
func test1():
	var s := SQLiteWrapper.new()
	s.set_path("user://test_data")
	s.set_foreign_keys(true)
	
	s.verbosity_level = 2
	s.open_db()
	s.drop_table("activity_log")
	s.drop_table("activity")
	
	for table_name in tables:
		s.create_table(table_name, tables[table_name])
	
	s.insert_rows("activity", [
		{name = "work", id = 0}, 
		{name = "play", id = 1}
	])
	var now := TimeUtils.now_nan()
	s.insert_rows("activity_log", [
		{activity = 0, timestamp = now}, 
		{activity = 0, timestamp = now + TimeUtils.nan(3600)}, 
		{activity = 1, timestamp = now + TimeUtils.nan(3600)},
		{activity = 1, timestamp = now + TimeUtils.nan(3600*2)}
	])
	pretty_print_res(s.select_rows("activity_log", "", ["activity", "timestamp"]))
	
	var coso := PoolStringArray()
	for key in CONSTANTS:
		coso.append(CONSTANTS[key] + " AS " + key)
	
	var query := "SELECT " + coso.join(", ") + ";"

	s.query(query)

	pretty_print_res(s.get_query_result())
	
	s.close_db()


	get_tree().quit(0)
func pretty_print_res(v: Array):
	if !v.size():
		print("query returned empty")
		return
	var first : Dictionary = v[0]
	var keys : Array = first.keys()
	var column_widths = {}
	
	for key in keys:
		var size : int = key.length()
		for entry in v:
			var str_ := str(entry[key])
			size = MathUtils.maxi(size, str_.length())
		column_widths[key] = size
	var headers = get_headers(column_widths)
	var separator : String = headers.separator
	var header : String = headers.header
	print(separator)
	print(header)
	print(separator)
	for entry in v:
		print_row(entry, column_widths)
	print(separator)
		
func print_row(row: Dictionary, column_widths: Dictionary = {}):
	var line := PoolStringArray()
	line.resize(row.size())
	var i := 0
	for key in row.keys():
		var val = row[key]
		var val_s := str(val)
		var column_width : int = column_widths.get(key, 0)
		match typeof(val):
			TYPE_INT, TYPE_REAL:
				line[i] = StringUtils.padl(val_s, column_width)
			_:
				line[i] = StringUtils.padr(val_s, column_width)
		i += 1
	print("| ",line.join(" | ")," |")

func get_headers(row_size: Dictionary = {}) -> Dictionary:
	var line := PoolStringArray()
	var line2 := line
	line.resize(row_size.size())
	line2.resize(row_size.size())
	var i := 0
	for key in row_size.keys():
		var res := StringUtils.padcl(key, row_size[key])
		line[i] = res
		line2[i] = "-".repeat(res.length())
		i += 1
	return {
		"header":"| "+line.join(" | ")+" |",
		"separator":"+-"+line2.join("-+-")+"-+"
	}
	
