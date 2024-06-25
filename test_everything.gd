extends Node


func _ready():
	var dir = Directory.new()
	

	var dirs := PoolStringArray(["res://"])
	var files := PoolStringArray()
	
	var abs_path : String
	var i := 0
	while i < dirs.size():
		var dir_path := dirs[i]
		i += 1
		dir.open(dir_path)
		dir.list_dir_begin(true, false)
		
		while true:
			var entry : String = dir.get_next()
			if !entry:
				break

			abs_path = dir_path.plus_file(entry)
			if dir.dir_exists(abs_path):
#				print("dir:", entry)
				dirs.push_back(abs_path)
			else:
#				print("file:", entry)
				files.push_back(abs_path)
		
	for file in files:
		var s : String = file
		
		if (s.get_extension() != "tscn"):
			continue 
		
		var name := s.get_file().trim_suffix(".tscn")
		
		if !(name.begins_with("test_") or name.ends_with("_test")):
			continue
		
		if file == filename:
			continue
		
		print(s)
		
		var SCENE : PackedScene = load(s)
		add_child(SCENE.instance())
	
	get_tree().quit(0)
	
