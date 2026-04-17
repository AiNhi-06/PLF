extends Area2D

# Đường dẫn đến map Nhi muốn chuyển tới (ví dụ sang Farm)
@export var target_map_path: String = "res://scenes/Map/Farm_Map.tscn"

func _on_body_entered(body):
	# Kiểm tra nếu đúng là player chạm vào cổng
	if body.name == "player" or body.name == "Player":
		# Gọi hàm change_map từ GameManager cực kỳ gọn nhẹ
		GameManager.change_map(target_map_path)
