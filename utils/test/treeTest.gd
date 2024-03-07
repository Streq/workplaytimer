extends Tree


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

func _ready():
	var tree = self
	var root = tree.create_item()
#	tree.set_hide_root(true)
	var child1 = tree.create_item(root)
	child1.set_text(2,"Lmao")
	var child2 = tree.create_item(root)
	child2.set_text(1,"Lmao2")
	var subchild1 = tree.create_item(child1)
	subchild1.set_text(0, "Subchild1")
	subchild1.set_editable(0, true)
	
