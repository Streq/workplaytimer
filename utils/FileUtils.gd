extends Object
class_name FileUtils
const ErrorUtils = preload("res://utils/ErrorUtils.gd")
 
func _init():
	var msg = "%s is an utility class, you are not supposed to instantiate it." % get_script().resource_path
	assert(false, msg)
	printerr(msg)


static func load_json_file_as_dict(json_path: String):
	var file = File.new()
	var error = file.open(json_path, file.READ)
	if error:
		push_warning("Couldn't open json file at \"{path}\". Error code {error} - {error_string}".format({
				"path": json_path,
				"error": str(error),
				"error_string": ErrorUtils.get_error_text(error)
			}))
		return null
	
	var text = file.get_as_text()
	var json : JSONParseResult = JSON.parse(text)
	
	file.close()
	
	if json.error:
		push_warning("Couldn't extract valid json from \"{path}\". Error code {error} - {error_text}, at line {error_line}.".format({
				"path": json_path,
				"error": str(json.error),
				"error_text": json.error_string,
				"error_line": str(json.error_line),
			}))
		return null

	return json.result


static func create_dir_for_file_if_absent(file_path) -> int:
	var file = file_path.get_file()
	var dir_path = file_path.trim_suffix(file)
	var directory = Directory.new()
	
	if directory.dir_exists(dir_path):
		return OK
	
	push_warning("Directory \"{dir}\" absent for \"{file}\", creating one.".format({
			"dir": dir_path, 
			"file": file
		}))
	var error = directory.make_dir_recursive(dir_path)
	
	if !error:
		return OK
	
	push_error("Directory \"{dir}\" could not be created. Error code {error}".format({
			"dir": dir_path,
			"error": error
		}))
	return error

static func save_json_file(path : String, dictionary := {}) -> int:
	var error = create_dir_for_file_if_absent(path)
	if error:
		return error
	var file = File.new()
	error = file.open(path, File.WRITE)
	if error:
		push_error("Couldn't create file at \"{file}\". Error code {error}.".format({
				"file": path,
				"error": str(error)
			}))
		return error
	file.store_string(JSON.print(dictionary,"\t"))
	file.close()
	return OK

static func open_or_create(path : String, mode := File.READ_WRITE) -> File:
	var file = File.new()
	
	var error = create_dir_for_file_if_absent(path)
	
	if error:
		return null
	
	error = file.open(path, mode) 
	
	if error == ERR_FILE_NOT_FOUND:
		push_warning("Couldn't find file \"{file}\". Creating it.".format({
				"file" : path
			}))
		error = file.open(path, File.WRITE_READ)
	
	if error == OK:
		return file

	push_error("Couldn't open file at \"{file}\". Error code is {error}.".format({
			"file" : path,
			"error" : error
		}))
	return null
static func create_if_absent(path : String) -> int:
	var file = File.new()
	
	if file.file_exists(path):
		return OK
	
	var error = create_dir_for_file_if_absent(path)
	
	if error:
		return error
	
	error = file.open(path, File.WRITE) 

	if error:
		push_error("Couldn't create file at \"{file}\". Error code is {error}.".format({
				"file" : path,
				"error" : error
			}))
		return error
	
	file.close()
	return OK

static func open_user_data():
	var file = ProjectSettings.globalize_path("user://")
	OS.shell_open(file)

static func delete(path: String) -> int:
	return Directory.new().remove(path)

static func rename(path: String, path_to: String) -> int:
	return Directory.new().rename(path, path_to)

static func get_text_file(path: String) -> String:
	var file := File.new()
	var error = open(file, path, File.READ)
	if error:
		return ""
	var ret := file.get_as_text()

	file.close()

	return ret

static func open(file: File, path: String, mode: int) -> int:
	var error := file.open(path, mode)
	if error:
		push_error("Couldn't open file at \"{path}\". Error code {error} - {error_string}".format({
				"path": path,
				"error": str(error),
				"error_string": ErrorUtils.get_error_text(error)
			}))
	return error
