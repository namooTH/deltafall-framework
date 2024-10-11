extends ColorRect

var currentSelectedIndex: int = 0:
	set(value):
		currentSelectedIndex = value
		currentSelected = $Scroller.displayedNodes[value]
var currentSelected: Node 

func _unhandled_input(event):
	if event.is_action_pressed("arrow_down"):
		currentSelectedIndex -= 1
	if event.is_action_pressed("arrow_up"):
		currentSelectedIndex += 1
