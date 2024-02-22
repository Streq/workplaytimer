extends Object
class_name UsefulCode


static func scan_controls(root:Node):
	var nodes = [root]
	var i = 0
	var p = Printer.new()
	while i < nodes.size():
		var node = nodes[i]
		nodes.append_array(node.get_children())
		if node is Control:
			node.connect("gui_input", p, "print_node_input", [node.name])
		i+=1
	root.add_child(p)
class Printer extends Node:
	func print_node_input(event, name):
		print(event, " ", name)
