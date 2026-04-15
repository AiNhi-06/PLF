extends Node2D

func _ready():
	# Khi map 2 vừa load xong, đưa player tới chỗ Marker2D
	if has_node("player") and has_node("Marker2D"):
		$player.global_position = $Marker2D.global_position
		
