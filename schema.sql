-- activity definition

CREATE TABLE activity (
	id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	name CHAR(255) NOT NULL
);

CREATE UNIQUE INDEX activity_name_IDX ON activity (name);


-- tag definition

CREATE TABLE tag (
	id INTEGER DEFAULT (0) NOT NULL PRIMARY KEY AUTOINCREMENT,
	name TEXT(255) NOT NULL
);

CREATE UNIQUE INDEX tag_name_IDX ON tag (name);


-- activity_log definition

CREATE TABLE "activity_log" (
	"timestamp" INTEGER NOT NULL,
	activity INTEGER NOT NULL REFERENCES activity(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- activity_tag definition

CREATE TABLE activity_tag (
	activity INTEGER NOT NULL REFERENCES activity(id) ON DELETE CASCADE ON UPDATE CASCADE,
	tag INTEGER NOT NULL REFERENCES tag(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- task definition

CREATE TABLE task (
	id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	activity INTEGER NOT NULL REFERENCES activity(id) ON DELETE CASCADE ON UPDATE CASCADE,
	goal INTEGER DEFAULT (0) NOT NULL,
	name TEXT NOT NULL,
	description TEXT, creation INTEGER DEFAULT (0) NOT NULL, 
	is_estimation INTEGER DEFAULT (0) NOT NULL, 
	marked_done INTEGER DEFAULT (0) NOT NULL
);


-- task_log definition

CREATE TABLE task_log (
	"timestamp" INTEGER NOT NULL,
	task INTEGER NOT NULL REFERENCES task(id) ON DELETE CASCADE ON UPDATE CASCADE
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
	cast(unixepoch('now', 'subsec') * 1000 as int) AS UNIX_MILLIS;


-- open_interval source

CREATE VIEW open_interval AS 
SELECT 
	s.timestamp as start,
	UNIX_MILLIS as end,
	s.activity,
	s.task,
	UNIX_MILLIS - s.timestamp as duration
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

CREATE TRIGGER insert_history_activity
INSTEAD OF INSERT ON history
FOR EACH ROW 
WHEN NEW.task IS NULL
BEGIN
	INSERT INTO activity_log (timestamp, activity) 
	VALUES (NEW.timestamp, NEW.activity);
END;

CREATE TRIGGER insert_history_task
INSTEAD OF INSERT ON history
FOR EACH ROW 
WHEN NEW.task IS NOT NULL
BEGIN
	INSERT INTO task_log (timestamp, task) 
	VALUES (NEW.timestamp, NEW.task);
END;

CREATE TRIGGER insert_interval_start
INSTEAD OF INSERT ON interval_start
FOR EACH ROW 

BEGIN
	SELECT RAISE(ABORT, "new interval start must be the latest for said task/activity") 
	WHERE EXISTS(
		SELECT 1
		FROM history
		WHERE task IS NEW.task AND (task IS NOT NULL OR activity = NEW.activity)
			AND 
			timestamp >= NEW.timestamp
	);

	SELECT RAISE(ABORT, "cannot start an ongoing activity") 
	WHERE EXISTS (
		SELECT 1 
		FROM open_interval 
		WHERE task IS NEW.task AND (task IS NOT NULL OR activity = NEW.activity)
	);

	
	INSERT INTO history (timestamp, activity, task) 
	VALUES (NEW.timestamp, NEW.activity, NEW.task);
END;

CREATE TRIGGER insert_interval_finish
INSTEAD OF INSERT ON interval_finish
FOR EACH ROW 
BEGIN
	SELECT RAISE(ABORT, "new interval finish must be the latest for said task/activity") 
	WHERE EXISTS(
		SELECT 1
		FROM history
		WHERE task IS NEW.task AND (task IS NOT NULL OR activity = NEW.activity)
			AND 
			timestamp >= NEW.timestamp
	);

	SELECT RAISE(ABORT, "cannot finish a finished activity") 
	WHERE NOT EXISTS (
		SELECT 1 
		FROM open_interval 
		WHERE task IS NEW.task AND (task IS NOT NULL OR activity = NEW.activity)
	);

	
	INSERT INTO history (timestamp, activity, task) 
	VALUES (NEW.timestamp, NEW.activity, NEW.task);
END;

