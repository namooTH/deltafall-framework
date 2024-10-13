extends Node

func _ready():
	var args = Array(OS.get_cmdline_args())
	if args.has("-s"):
		print("starting server...")
		get_tree().change_scene_to_file("res://Game/gameSystems/global/server/server.tscn")
