extends Control


func _ready():
	$mainBar.size.x = sqrt(size.y*size.y + $barAnchor.position.x*$barAnchor.position.x) + 20
	$mainBar.rotation = ($mainBar.position.angle_to_point($barAnchor.position))

func _on_resized():
	$mainBar.size.x = sqrt(size.y*size.y + $barAnchor.position.x*$barAnchor.position.x) + 20
	$mainBar.rotation = ($mainBar.position.angle_to_point($barAnchor.position))
