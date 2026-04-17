extends Node2D

func _ready():
	GameManager.main_scene = self
	change_map("res://scenes/Map/Tower_Map.tscn")

func change_map(map_path: String):
	# Bảo Godot: "Đợi tí rồi chạy hàm _do_change_map"
	call_deferred("_do_change_map", map_path)

# --- BẠN THIẾU DÒNG NÀY NÈ ---
func _do_change_map(map_path: String):
	# 1. Xóa map cũ
	for child in $CurrentScene.get_children():
		child.queue_free()
		
	# 2. Load map mới
	var new_map_resource = load(map_path)
	if new_map_resource:
		var new_map = new_map_resource.instantiate()
		$CurrentScene.add_child(new_map)
		
		# Đợi 2 khung hình để tọa độ ổn định
		await get_tree().process_frame
		await get_tree().process_frame
		
		# 3. Di chuyển Player
		if new_map.has_node("SpawnPoint"):
			var spawn_node = new_map.get_node("SpawnPoint")
			print("Toa do Marker trong Map: ", spawn_node.position)
			print("Toa do Marker trong the gioi: ", spawn_node.global_position)
			$player.global_position = spawn_node.global_position
