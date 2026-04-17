extends Node2D

func _ready():
	GameManager.main_scene = self
	change_map("res://scenes/Map/Tower_Map.tscn")

func change_map(map_path: String):
	call_deferred("_do_change_map", map_path)

func _do_change_map(map_path: String):
	# 1. XÓA MAP CŨ
	for child in $CurrentScene.get_children():
		child.queue_free()
		
	# 2. TẠO MAP MỚI
	var new_map_resource = load(map_path)
	if new_map_resource:
		var new_map = new_map_resource.instantiate()
		$CurrentScene.add_child(new_map)
		
		# 3. BỐC PLAYER VÀO MAP MỚI (ĐỂ Y-SORT HOẠT ĐỘNG)
		# Chỗ này Nhi cực kỳ lưu ý: Tên node trong Main phải là "player"
		var p = find_child("player", true, false)
		
		if p != null:
			var old_parent = p.get_parent()
			if old_parent != null:
				old_parent.remove_child(p)
			
			new_map.add_child(p)
			
			# Đợi Godot tính toán tọa độ xong
			await get_tree().process_frame
			await get_tree().process_frame
			
			# 4. DI CHUYỂN ĐẾN ĐIỂM SPAWN
			var marker_name = ""
			if new_map.has_node("SpawnFormTower"):
				marker_name = "SpawnFormTower"
			elif new_map.has_node("SpawnPoint"):
				marker_name = "SpawnPoint"
				
			if marker_name != "":
				var spawn_node = new_map.get_node(marker_name)
				p.global_position = spawn_node.global_position
				print("Thành công: Đã đưa player tới ", marker_name)
		else:
			print("Lỗi: Không tìm thấy node tên 'player' trong scene Main!")
	else:
		print("Lỗi: Không load được file map tại: ", map_path)
