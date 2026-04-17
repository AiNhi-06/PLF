extends Node

# Các biến toàn cục (Global) - Đi đâu cũng không mất
var player_health = 100
var gold = 0
var inventory_items = [] # Danh sách item Nhi đã nhặt

# Biến để lưu tham chiếu đến Scene Main (để gọi hàm đổi map)
var main_scene = null

var is_changing_scene = false
func add_gold(amount):
	gold += amount
	print("Vàng hiện tại: ", gold)
	

	# Hàm này để các cổng dịch chuyển gọi tới
func change_map(map_path: String):
	if is_changing_scene: return # Nếu đang chuyển rồi thì thôi
	
	is_changing_scene = true
	main_scene.change_map(map_path)
	
	# Đợi 1 chút rồi mới cho phép chuyển tiếp
	await get_tree().create_timer(0.5).timeout
	is_changing_scene = false
