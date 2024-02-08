extends Node
class_name FileUtils

static func load_json_file(json_path: String) -> Object:
	var file = File.new()
	var error = file.open(json_path, file.READ)
	if(error):
		push_warning("couldn't open json file at {path}, error code {error}".format({
				"error": str(error),
				"path": json_path
			}))
		return null
	var text = file.get_as_text()
	var json : JSONParseResult = JSON.parse(text)
	file.close()
	if json.error:
		push_warning("couldn't read json file at {path}, error code {error}".format({
				"error": str(json.error),
				"path": json_path
			}))
		return null
	return json.result


static func create_dir_for_file_if_not_exists(file_path):
	var file = file_path.get_file()
	var dir_path = file_path.trim_suffix(file)
	var directory = Directory.new()
	if !directory.dir_exists(dir_path):
		push_warning("directory {dir} absent for {file}, creating one.".format({
				"dir": dir_path, 
				"file": file
			}))
		directory.make_dir_recursive(dir_path)

static func save_json_file(path : String, dictionary := {}) -> int:
	create_dir_for_file_if_not_exists(path)
	var file = File.new()
	var error = file.open(path, File.WRITE)
	if error:
		push_error("couldn't create file at {file}, error code {error}.".format({
			"file": path,
			"error": str(error)
		}))
		return error
	file.store_string(JSON.print(dictionary,"\t"))
	file.close()
	return 0
