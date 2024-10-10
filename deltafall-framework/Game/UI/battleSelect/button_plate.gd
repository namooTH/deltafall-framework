extends ColorRect

var currentSelected: int = 0

func _unhandled_input(event):
	if event.is_action_pressed("arrow_down"):
		$Scroller.displayedNodes
	if event.is_action_pressed("arrow_up"):
		$Scroller.scrollUP(1)
