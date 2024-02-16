extends Node
func get_one(from_group):
	var members = get_tree().get_nodes_in_group(from_group)
	return members[0] if members else null
func exists(group):
	return get_tree().has_group(group)
