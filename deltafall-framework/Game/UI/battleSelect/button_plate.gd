extends ColorRect

var allNode: Array = []

func calcTotalRect(nodes: Array) -> Rect2: 
	return Rect2(nodes[0].position, (nodes[-1].position + nodes[-1].size) - nodes[0].position)

func _process(delta):
	#print(allNode)
	if allNode.size() > 0:
		var totalSize = calcTotalRect(allNode)
		
func _on_child_entered_tree(node):
	if node.name != "debug":
		allNode.append(node)
