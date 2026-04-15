extends Area2D

func _on_body_entered(body: Node2D) -> void:
	# Kiểm tra nếu đúng là nhân vật chạm vào
	if body.name == "player":
		# Chuyển sang Map 2
		get_tree().change_scene_to_file("res://scenes/tile_map.tscn")
