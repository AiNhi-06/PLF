extends Area2D

func _on_body_entered(body: Node2D) -> void:
	# 1. Kiểm tra xem có đúng là player không
	if body.name == "player":
		# 2. Gọi GameManager để đổi sang Map Tower
		# Nhi kiểm tra lại đường dẫn file Tower_Map.tscn cho chính xác nhé
		GameManager.change_map("res://scenes/Map/Tower_Map.tscn")
