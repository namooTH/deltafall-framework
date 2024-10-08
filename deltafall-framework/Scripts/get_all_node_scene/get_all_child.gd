func get_all_childs(node: Node):
	var all_child = []
	for child in node.get_children():
		var childs = child.get_children()
		if childs:
			all_child.append_array(get_all_childs(child))
		all_child.append(child)
	return all_child
