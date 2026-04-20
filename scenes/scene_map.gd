extends Node2D # Hoặc Node tùy loại node gốc của Nhi

func _ready():
	# Đợi 1 frame để chắc chắn Player và các Marker2D đã được load xong
	await get_tree().process_frame
	
	if GameManager.target_spawn_name != "":
		# Tìm Marker2D (node con của Map này)
		var spawn_node = find_child(GameManager.target_spawn_name, true, false)
		
		# Tìm Player (như Nhi đã tách ra cảnh Main)
		var player_node = get_tree().root.find_child("player", true, false)
		if player_node == null:
			player_node = get_tree().root.find_child("Player", true, false)
		
		# Chỉ xử lý khi player đã là con/cháu của map hiện tại để tránh đè logic ở Main
		if spawn_node and player_node and is_ancestor_of(player_node):
			player_node.global_position = spawn_node.global_position
			print("Đã dịch chuyển player tới: ", GameManager.target_spawn_name)
			
			# Reset lại để không bị nhảy vị trí lần sau
			GameManager.target_spawn_name = ""
