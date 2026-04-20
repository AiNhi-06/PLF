extends Node2D

const TOWER_MAP_PATH := "res://scenes/Map/Tower_Map.tscn"
const FARM_MAP_PATH := "res://scenes/Map/Farm_Map.tscn"

@onready var health_bar: TextureProgressBar = $CanvasLayer/Hotbar/HealthBar
@onready var stamina_bar: TextureProgressBar = $CanvasLayer/Hotbar/StaminaBar

func _ready():
	GameManager.main_scene = self
	_setup_status_bars()
	change_map("res://scenes/Map/Tower_Map.tscn")

func _setup_status_bars() -> void:
	if health_bar:
		health_bar.min_value = 0.0
		health_bar.max_value = GameManager.max_health
		health_bar.value = GameManager.current_health

	if stamina_bar:
		stamina_bar.min_value = 0.0
		stamina_bar.max_value = GameManager.max_stamina
		stamina_bar.value = GameManager.current_stamina

	if not GameManager.health_changed.is_connected(_on_health_changed):
		GameManager.health_changed.connect(_on_health_changed)
	if not GameManager.stamina_changed.is_connected(_on_stamina_changed):
		GameManager.stamina_changed.connect(_on_stamina_changed)

func _on_health_changed(current: float, maximum: float) -> void:
	if not health_bar:
		return
	health_bar.max_value = maximum
	health_bar.value = current

func _on_stamina_changed(current: float, maximum: float) -> void:
	if not stamina_bar:
		return
	stamina_bar.max_value = maximum
	stamina_bar.value = current

func change_map(map_path: String):
	_close_inventory_on_map_change()
	call_deferred("_do_change_map", map_path)

func _close_inventory_on_map_change():
	var inventory_ui = find_child("InventoryUI", true, false)
	if inventory_ui:
		if inventory_ui.has_method("close_inventory"):
			inventory_ui.close_inventory()
		elif inventory_ui is Control:
			inventory_ui.visible = false
	# Tránh trạng thái pause làm kẹt chuyển cảnh.
	get_tree().paused = false

func _resolve_spawn_alias(marker_name: String) -> String:
	match marker_name:
		"SpawnFormTown":
			return "SpawnFormTower"
		"SpawnFormFarm":
			return "SpawnFromFarm"
		_:
			return marker_name

func _do_change_map(map_path: String):
	var previous_map_path := ""
	var current_maps = $CurrentScene.get_children()
	if current_maps.size() > 0:
		var old_map = current_maps[0]
		if old_map is Node and old_map.scene_file_path != "":
			previous_map_path = old_map.scene_file_path

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
		if p == null:
			p = find_child("Player", true, false)
		
		if p != null:
			var old_parent = p.get_parent()
			if old_parent != null:
				old_parent.remove_child(p)
			
			new_map.add_child(p)
			
			# Đợi Godot tính toán tọa độ xong
			await get_tree().process_frame
			await get_tree().process_frame
			
			# 4. DI CHUYỂN ĐẾN ĐIỂM SPAWN
			var marker_name = GameManager.target_spawn_name
			if marker_name != "":
				marker_name = _resolve_spawn_alias(marker_name)
			if marker_name == "" or not new_map.has_node(marker_name):
				# Fallback theo hướng chuyển map.
				if map_path == TOWER_MAP_PATH:
					if previous_map_path == FARM_MAP_PATH and new_map.has_node("SpawnFormFarm"):
						marker_name = "SpawnFormFarm"
					elif previous_map_path == FARM_MAP_PATH and new_map.has_node("SpawnFromFarm"):
						marker_name = "SpawnFromFarm"
					elif new_map.has_node("SpawnPoint"):
						marker_name = "SpawnPoint"
				elif map_path == FARM_MAP_PATH:
					if previous_map_path == TOWER_MAP_PATH and new_map.has_node("SpawnFormTown"):
						marker_name = "SpawnFormTown"
					elif previous_map_path == TOWER_MAP_PATH and new_map.has_node("SpawnFormTower"):
						marker_name = "SpawnFormTower"
					elif new_map.has_node("SpawnPoint"):
						marker_name = "SpawnPoint"
				elif new_map.has_node("SpawnPoint"):
					marker_name = "SpawnPoint"
				
			if marker_name != "":
				var spawn_node = new_map.get_node(marker_name)
				p.global_position = spawn_node.global_position
				if p is CharacterBody2D:
					p.velocity = Vector2.ZERO
				# Đặt lại thêm 1 lần ở frame kế để triệt tiêu độ lệch do đà di chuyển.
				await get_tree().process_frame
				p.global_position = spawn_node.global_position
				print("Thành công: Đã đưa player tới ", marker_name)
			
			GameManager.target_spawn_name = ""
		else:
			print("Lỗi: Không tìm thấy node tên 'player' trong scene Main!")
	else:
		print("Lỗi: Không load được file map tại: ", map_path)
