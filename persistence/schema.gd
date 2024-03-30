class_name Schema
# the following query creates the whole schema from scratch

const DEFINITION = """
-- activity definition
CREATE TABLE activity (id INTEGER PRIMARY KEY AUTOINCREMENT,name CHAR(255));
CREATE UNIQUE INDEX activity_name_IDX ON activity (name);


-- activity_log definition
CREATE TABLE activity_log (
	"timestamp" INTEGER,
	activity INTEGER,
	CONSTRAINT FK_activity_log_activity FOREIGN KEY (activity) REFERENCES activity(id)
);


-- tag definition
CREATE TABLE tag (
	id INTEGER DEFAULT (0) NOT NULL PRIMARY KEY AUTOINCREMENT,
	name TEXT(255) NOT NULL
);
CREATE UNIQUE INDEX tag_name_IDX ON tag (name);


-- activity_tag definition
CREATE TABLE activity_tag (
	activity INTEGER NOT NULL,
	tag INTEGER NOT NULL,
	CONSTRAINT activity_tag_activity_FK FOREIGN KEY (activity) REFERENCES activity(id),
	CONSTRAINT activity_tag_tag_FK FOREIGN KEY (tag) REFERENCES tag(id)
);


-- numbered_logs source
CREATE VIEW numbered_logs AS 
	SELECT
		l.*,
		ROW_NUMBER() OVER (ORDER BY l.activity, l.timestamp) AS row_num
	FROM activity_log l join activity_running r on l.activity = r.activity 
	WHERE r.running = 0 OR r.latest_log <> l.timestamp;


-- activity_running source
CREATE VIEW activity_running AS 
SELECT 
	activity,
	COUNT(*)%2 = 1 as running,
	max(timestamp) as latest_log
FROM activity_log group by activity;


-- activity_intervals source
CREATE VIEW activity_intervals AS
SELECT a.activity, a.timestamp AS start, b.timestamp AS end, b.timestamp - a.timestamp as duration
FROM (
	SELECT 
		row_num, timestamp, activity
	FROM numbered_logs
	WHERE row_num % 2 = 1
) a
JOIN (
	SELECT 
		row_num, timestamp, activity
	FROM numbered_logs
	WHERE row_num % 2 = 0
) b ON a.row_num + 1 = b.row_num and a.activity = b.activity;

"""
