class_name Schema extends Object
func _init():
	var msg = "%s is an utility class, you are not supposed to instantiate it." % get_script().resource_path
	assert(false, msg)
	printerr(msg)


static func load_definition() -> String:
	return FileUtils.get_text_file("res://schema.sql")

const TEST_DATA_INSERT = """
INSERT INTO activity (id,name) VALUES
	 (0,'work'),
	 (1,'play'),
	 (2,'dev');
INSERT INTO activity_log ("timestamp",activity) VALUES
	 (1711756957744,0),
	 (1711756957744,0),
	 (1711753357744,1),
	 (1711756957744,1),
	 (1711756957744,2),
	 (1711760557744,2),
	 (1711760557744,0);
	 
INSERT INTO tag (id,name) VALUES
	 (1,'productive');
INSERT INTO activity_tag (activity,tag) VALUES
	 (0,1),
	 (2,1);
INSERT INTO task (id,activity,goal,name,description,creation,is_estimation,marked_done) VALUES
	 (0,0,3600000,'"hour long work"','just work for an hour man cmon',0,0,0);
INSERT INTO task_log ("timestamp",task) VALUES
	 (1711760557744,0),
	 (1711780557744,0);
"""
