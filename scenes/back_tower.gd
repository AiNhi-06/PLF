extends Area2D

func _on_body_entered(body: Node2D) -> void:
	# 1. Kiểm tra xem có đúng là player không
	if body.name == "player" or body.name == "Player":
		# 2. Chuyển map qua GameManager để giữ nguyên flow trong Main scene
		GameManager.target_spawn_name = "SpawnFormFarm"
		GameManager.change_map("res://scenes/Map/Tower_Map.tscn")
