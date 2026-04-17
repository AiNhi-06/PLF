extends Node

# Các biến toàn cục (Global) - Đi đâu cũng không mất
var player_health = 100
var gold = 0
var inventory_items = [] # Danh sách item Nhi đã nhặt

# Biến để lưu tham chiếu đến Scene Main (để gọi hàm đổi map)
var main_scene = null

func add_gold(amount):
	gold += amount
	print("Vàng hiện tại: ", gold)
	
	# Hàm này để các cổng dịch chuyển gọi tới
func change_map(map_path: String):
	if main_scene:
		# Sử dụng call_deferred để tránh lỗi vật lý khi đang va chạm
		main_scene.call_deferred("_do_change_map", map_path)
	else:
		print("Cảnh báo: Chưa gán main_scene cho GameManager!")
