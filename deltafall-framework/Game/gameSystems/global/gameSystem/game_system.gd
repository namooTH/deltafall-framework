extends Node

func _ready():
	pass # Replace with function body.

func playMusic(path: String):
	if "res://" in path:
		$globalMusic.stream = load(path)
	$globalMusic.play()
