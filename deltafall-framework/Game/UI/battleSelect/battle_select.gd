extends Control

func _ready():
	$bar.size.x = sqrt(size.y*size.y + $barAnchor.position.x*$barAnchor.position.x) + 20
	$bar.rotation = ($bar.position.angle_to_point($barAnchor.position))

func _on_resized():
	$bar.size.x = sqrt(size.y*size.y + $barAnchor.position.x*$barAnchor.position.x) + 20
	$bar.rotation = ($bar.position.angle_to_point($barAnchor.position))
