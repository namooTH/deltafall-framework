extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	GameSystem.playMusic("res://Sounds/rudebusterZylX050Remake.mp3")
	$BattleDialogueBox.battleStarted()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
