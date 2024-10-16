extends Control

func createButton(buttonName: String, icon: Texture):
	var button = $mainBar/buttonsPlate/Scroller/unrelated_buttonTemplate.duplicate()
	button.name = buttonName
	button.get_node("icon").texture = icon
	button.get_node("iconShadow").texture = icon
	$mainBar/buttonsPlate/Scroller.add_child(button)
	button.show()

var icons: CompressedTexture2D = preload("res://Art/UI_art/Icons/battle_icons.png")
func _ready():
	for button in await Client.requestGameData("battleSelection"):
		createButton(button, await Client.requestTexture(button))
	
	$mainBar.size.x = sqrt(size.y*size.y + $barAnchor.position.x*$barAnchor.position.x) + 20
	$mainBar.rotation = ($mainBar.position.angle_to_point($barAnchor.position))
	
func _on_resized():
	$mainBar.size.x = sqrt(size.y*size.y + $barAnchor.position.x*$barAnchor.position.x) + 20
	$mainBar.rotation = ($mainBar.position.angle_to_point($barAnchor.position))
