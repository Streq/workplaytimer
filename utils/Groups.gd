extends Node
func get_one(from_group: String):
	var members = get_tree().get_nodes_in_group(from_group)
	return members[0] if members else null
func exists(group: String) -> bool:
	return get_tree().has_group(group)
func get_all(from_group: String) -> Array:
	return get_tree().get_nodes_in_group(from_group)
	
