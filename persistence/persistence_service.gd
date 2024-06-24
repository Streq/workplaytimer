extends Node


class Activity:
	func _init(name: String, id: int = -1, color: Color = Color(0), icon: Texture = null, groups := []):
		self.id = id
		self.name = name
		self.color = color
		self.icon = icon
		self.groups = groups
	var id : int
	var name : String
	var color : Color
	var icon : Texture
	var groups : Array
	

func get_activity(id: int) -> Activity:
	return null
func get_activity_by_name(name: String) -> Activity:
	return null
func get_activities() -> Array:
	return []
func insert_activity(activity: Activity) -> Activity:
	return null
func update_activity(activity: Activity) -> Activity:
	return null
func upsert_activity(activity: Activity) -> Activity:
	return null
func delete_activity(id: int) -> bool:
	return false

class Group:
	func _init(name: String, id: int = -1, color: Color = Color(0), icon: Texture = null, activities := []):
		self.id = id
		self.name = name
		self.color = color
		self.icon = icon
		self.activities = activities
	var id : int
	var name : String
	var color : Color
	var icon : Texture
	var activities : Array

func get_group(id: int) -> Group:
	return null
func get_group_by_name(name: String) -> Group:
	return null
func get_groups() -> Array:
	return []
func insert_group(group: Group) -> Group:
	return null
func update_group(group: Group) -> Group:
	return null
func upsert_group(group: Group) -> Group:
	return null
func delete_group(id: int) -> bool:
	return false


class Interval:
	var activity : Activity
	var start : int
	var end : int
	var tags : Array

func get_intervals(activity: Activity, start : int = -1, end : int = -1) -> Array:
	return []
#func get_group_by_name(name: String) -> Group:
#	return null
#func get_groups() -> Array:
#	return []
#func insert_group(group: Group) -> Group:
#	return null
#func update_group(group: Group) -> Group:
#	return null
#func upsert_group(group: Group) -> Group:
#	return null
#func delete_group(id: int) -> bool:
#	return false
