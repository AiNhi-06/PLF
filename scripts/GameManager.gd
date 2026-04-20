extends Node

var target_spawn_name: String = ""
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
	
	# Sử dụng call_deferred để tránh lỗi "physics callback" (lỗi đỏ Nhi gặp)
	# Nó sẽ đợi các tính toán vật lý xong xuôi rồi mới đổi map
	call_deferred("_deferred_change_map", map_path)
	
	# Hàm phụ trợ để thực hiện việc đổi map an toàn
func _deferred_change_map(map_path: String):
	if main_scene:
		main_scene.change_map(map_path)
	
	# Đợi 1 chút rồi mới cho phép chuyển tiếp lần sau
	await get_tree().create_timer(0.5).timeout
	is_changing_scene = false
