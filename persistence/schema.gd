class_name Schema
# the following query creates the whole schema from scratch

const DEFINITION = """
-- activity definition

CREATE TABLE activity (id INTEGER PRIMARY KEY AUTOINCREMENT,name CHAR(255));

CREATE UNIQUE INDEX activity_name_IDX ON activity (name);


-- tag definition

CREATE TABLE tag (
	id INTEGER DEFAULT (0) NOT NULL PRIMARY KEY AUTOINCREMENT,
	name TEXT(255) NOT NULL
);

CREATE UNIQUE INDEX tag_name_IDX ON tag (name);


-- task_log definition

CREATE TABLE task_log (
	"timestamp" INTEGER NOT NULL,
	task INTEGER NOT NULL
);


-- activity_log definition

CREATE TABLE "activity_log" (
	"timestamp" INTEGER,
	activity INTEGER,
	CONSTRAINT history_activity_FK FOREIGN KEY (activity) REFERENCES activity(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- activity_tag definition

CREATE TABLE activity_tag (
	activity INTEGER NOT NULL,
	tag INTEGER NOT NULL,
	CONSTRAINT activity_tag_activity_FK FOREIGN KEY (activity) REFERENCES activity(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT activity_tag_tag_FK FOREIGN KEY (tag) REFERENCES tag(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- task definition

CREATE TABLE task (
	id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	activity INTEGER NOT NULL,
	goal INTEGER DEFAULT (0) NOT NULL,
	name TEXT NOT NULL,
	description TEXT, creation INTEGER DEFAULT (0) NOT NULL, is_estimation INTEGER DEFAULT (0) NOT NULL, marked_done INTEGER DEFAULT (0) NOT NULL,
	CONSTRAINT task_activity_FK FOREIGN KEY (activity) REFERENCES activity(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- activity_progress source

CREATE VIEW activity_progress AS 
SELECT activity, sum(duration) AS progress
FROM interval
GROUP BY activity;


-- closed_interval source

CREATE VIEW closed_interval AS
SELECT
	s.timestamp AS start, 
	f.timestamp AS end, 
	s.activity, 
	s.task,
	f.timestamp - s.timestamp as duration
FROM interval_start s join interval_finish f
ON 	s.interval_id = f.interval_id
AND	(	s.task = f.task 
	OR	(	s.task IS NULL 
		AND	f.task IS NULL 
		AND	s.activity = f.activity
		)
	);


-- history source

CREATE VIEW history AS 
SELECT timestamp, activity, null as task from activity_log 
UNION ALL 
SELECT timestamp, activity, t.id as task from task_log tl join task t where tl.task = t.id
ORDER BY timestamp;


-- history_numbered source

CREATE VIEW history_numbered AS 
SELECT
	h.*,
	ROW_NUMBER() OVER (
		PARTITION BY h.activity, h.task
		ORDER BY h.timestamp
	) AS id
FROM history h;


-- "interval" source

CREATE VIEW interval AS 
SELECT * FROM closed_interval 
UNION ALL
select * FROM open_interval;


-- interval_finish source

CREATE VIEW interval_finish AS 
SELECT timestamp, activity, task, (id-1)/2 as interval_id 
FROM history_numbered
where history_numbered.id % 2 = 0;


-- interval_start source

CREATE VIEW interval_start AS 
SELECT timestamp, activity, task, id/2 as interval_id 
FROM history_numbered h
where h.id % 2 = 1;


-- now source

CREATE VIEW now AS
SELECT 
	strftime("%s", 'now') as UNIX, 
	julianday('now') as JULIAN_DAY, 
	(julianday('now') - 2440587.5) * 86400 as UNIX_FLOAT, 
	(julianday('now') - 2440587.5) * 86400 * 1000 AS UNIX_FLOAT_MILLIS, 
	(julianday('now') - 2440587.5) * 86400 * 1000 * 1000 AS UNIX_FLOAT_MICROS,
	(julianday('now') - 2440587.5) * 86400 * 1000 * 1000 * 1000 AS UNIX_FLOAT_NANOS,
	cast(((julianday('now') - 2440587.5) * 86400 * 1000) as int) AS UNIX_MILLIS,
	cast(((julianday('now') - 2440587.5) * 86400 * 1000 * 1000) as int) AS UNIX_MICROS,
	cast(((julianday('now') - 2440587.5) * 86400 * 1000 * 1000 * 1000) as int) AS UNIX_NANOS;


-- open_interval source

CREATE VIEW open_interval AS 
SELECT 
	s.timestamp as start,
	UNIX_NANOS as end,
	s.activity,
	s.task,
	UNIX_NANOS - s.timestamp as duration
FROM (
	interval_start s LEFT JOIN interval_finish f 
		ON 	s.interval_id = f.interval_id
		AND	(	s.task = f.task 
		OR	(	s.task IS NULL 
			AND	f.task IS NULL 
			AND	s.activity = f.activity
			)
		)
), now
WHERE f.interval_id IS NULL;


-- task_progress source

CREATE VIEW task_progress AS
SELECT task, sum(duration) AS progress
FROM interval
WHERE task IS NOT NULL 
GROUP BY task;

"""
