extends Node2D

func _ready():
	# 1. Đăng ký scene này với GameManager để có thể gọi từ bất cứ đâu
	GameManager.main_scene = self
	
	# 2. Load map đầu tiên khi vừa mở game
	# Nhi kiểm tra lại đường dẫn này cho đúng với máy của Nhi nhé
	change_map("res://scenes/Map/Tower_Map.tscn")

# Hàm này nhận lệnh đổi map
func change_map(map_path: String):
	# Dùng call_deferred để đợi hết khung hình vật lý, tránh lỗi va chạm
	call_deferred("_do_change_map", map_path)

# Hàm thực hiện việc xóa map cũ và thêm map mới
func _do_change_map(map_path: String):
	# 1. Xóa tất cả các map đang có trong CurrentScene
	for child in $CurrentScene.get_children():
		child.queue_free()
		
	# 2. Kiểm tra và load file map mới
	var new_map_resource = load(map_path)
	if new_map_resource:
		var new_map = new_map_resource.instantiate()
		
		# 3. Thêm map mới vào làm con của CurrentScene
		$CurrentScene.add_child(new_map)
		
		# 4. Đưa player tới vị trí SpawnPoint của map mới
		if new_map.has_node("SpawnPoint"):
			var spawn_pos = new_map.get_node("SpawnPoint").global_position
			$player.global_position = spawn_pos
		else:
			print("Cảnh báo: Map mới không có node Marker2D tên là SpawnPoint!")
	else:
		print("Lỗi: Không tìm thấy file map tại đường dẫn: ", map_path)
