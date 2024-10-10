extends Control

@export var padding: Vector2 = Vector2(10,10)
@export var scrollable: bool = true
@export var mode: String = "y"

@export var preventControlRotatedClipBug: bool = true

@export var isCentered: bool = false

var displayedNodes = []
var cachedDownNodes = []
var cachedUpperNodes = []

func _ready():
	for child in get_children(): checkNode(child) 

func calcTotalRect(nodes: Array) -> Rect2: 
	return Rect2(nodes[0].position, (nodes[-1].position + nodes[-1].size) - nodes[0].position)
func cullOutOfBoundsY():
	while len(displayedNodes) > 1 and displayedNodes[-1].position.y >= (self.size + displayedNodes[-1].size).y:
		displayedNodes[-1].hide()
		cachedDownNodes.append(displayedNodes[-1])
		displayedNodes.erase(displayedNodes[-1])
	while len(displayedNodes) > 1 and  displayedNodes[0].position.y <= -displayedNodes[0].size.y * 2:
		displayedNodes[0].hide()
		cachedUpperNodes.append(displayedNodes[0])
		displayedNodes.erase(displayedNodes[0])
func fillInNodesY():
	if not displayedNodes:
		return
	while cachedDownNodes and displayedNodes[-1].position.y + displayedNodes[-1].size.y <= self.size.y:
		displayedNodes.append(cachedDownNodes[-1])
		displayedNodes[-1].show()
		cachedDownNodes.pop_back()
	while cachedUpperNodes and displayedNodes[0].position.y >= 0:
		displayedNodes.insert(0, cachedUpperNodes[-1])
		displayedNodes[0].show()
		displayedNodes[0].position.y = -displayedNodes[0].size.y
		cachedUpperNodes.pop_back()
func cullOutOfBoundsX():
	while len(displayedNodes) > 1 and displayedNodes[-1].position.x >= (self.size + displayedNodes[-1].size).x:
		displayedNodes[-1].hide()
		cachedDownNodes.append(displayedNodes[-1])
		displayedNodes.erase(displayedNodes[-1])
	while len(displayedNodes) > 1 and  displayedNodes[0].position.x <= -displayedNodes[0].size.x * 2:
		displayedNodes[0].hide()
		cachedUpperNodes.append(displayedNodes[0])
		displayedNodes.erase(displayedNodes[0])
func fillInNodesX():
	if not displayedNodes:
		return
	while cachedDownNodes and displayedNodes[-1].position.x + displayedNodes[-1].size.x <= self.size.x:
		displayedNodes.append(cachedDownNodes[-1])
		displayedNodes[-1].show()
		cachedDownNodes.pop_back()
	while cachedUpperNodes and displayedNodes[0].position.x >= 0:
		displayedNodes.insert(0, cachedUpperNodes[-1])
		displayedNodes[0].show()
		displayedNodes[0].position.x = -displayedNodes[0].size.x
		cachedUpperNodes.pop_back()

#func insertNode(index: int = -1):
#	pass
#func sortNodes():
#	pass

func scrollUP(index: int):
	for i in range(index):
		scrollVelocity.x -= displayedNodes[0].size.x + padding.x
func scrollDOWN(index: int):
	for i in range(index):
		scrollVelocity.x += displayedNodes[-1].size.x + padding.x

var scrollVelocity: Vector2 = Vector2.ZERO
func _process(delta):
	#scrollVelocity -= 1
	#print(len(displayedNodes))

	#var fullRect = calcTotalRect(displayedNodes)
	#$debug_size.size = fullRect.size
	#$debug_size.position = fullRect.position
	#if isCentered: displayedNodes[0].position.x = 0
	update() 
	if mode == "x":
		cullOutOfBoundsX()
		fillInNodesX()
	else:
		cullOutOfBoundsY()
		fillInNodesY()

	smoothVelocity = lerp(smoothVelocity, Vector2.ZERO, delta * 5)
	if displayedNodes:
		if scrollVelocity == Vector2.ZERO and isCentered: scrollVelocity.x += (size.x / 2 - calcTotalRect(displayedNodes).size.x / 2) - displayedNodes[0].position.x
		displayedNodes[0].position.x += scrollVelocity.x + smoothVelocity.x
		if preventControlRotatedClipBug:
			if (displayedNodes[0].position).x < 0: displayedNodes[0].hide()
			if (displayedNodes[-1].position).x > size.x: displayedNodes[-1].hide()
	
	scrollVelocity = Vector2.ZERO

func update():
	var lastNode = null
	if mode == "x":
		for node in displayedNodes:
			node.show()
			if lastNode:
				node.position.x = lastNode.position.x + lastNode.size.x + padding.x
				node.position.y = lastNode.position.y #+ lastNode.size.x
			lastNode = node	
	else:
		for node in displayedNodes:
			node.show()
			if lastNode:
				node.position.y = lastNode.position.y + lastNode.size.y + padding.y
				node.position.x = lastNode.position.x #+ lastNode.size.x
			lastNode = node
	
var smoothVelocity: Vector2 = Vector2.ZERO
var pressedPos
func _input(event):
	if scrollable:
		if event.is_action_pressed("click"):
			pressedPos = event.position
		if event is InputEventMouseMotion and pressedPos:
			scrollVelocity = event.position - pressedPos
			pressedPos = event.position
		if event.is_action_released("click") and pressedPos:
			pressedPos = null
			
		smoothVelocity.y += (-event.get_action_strength("scroll_down") + event.get_action_strength("scroll_up")) * 2.0
	if event.is_action_pressed("arrow_down"):
		scrollDOWN(1)
	if event.is_action_pressed("arrow_up"):
		scrollUP(1)
	
func checkNode(node):
	if node in cachedDownNodes or node in cachedUpperNodes or node in displayedNodes:
		return
	
	if !"unrelated_" in node.name and !node is Control:
		var errormsg = "%s is NOT in the Control class." % node
		#GlobalMessage.appendLinuxStyleDebugText(["[color=red]BAD[/color]", errormsg])
		push_error(errormsg)
		return
	if not "unrelated_" in node.name:
		displayedNodes.append(node)
		update()

func _on_child_entered_tree(node):
	checkNode(node)
func _on_child_exiting_tree(node):
	pass # Replace with function body.
